ARG RUBY_VERSION=3.3.4-bookworm
ARG NODE_VERSION=18-slim

# ------------------------------------------------------------------------------
# Dependencies stage: NodeJS
# ------------------------------------------------------------------------------
FROM node:${NODE_VERSION} AS nodejs

ARG RAILS_ENV

ENV DEPS_HOME=/deps
ENV NODE_ENV=${RAILS_ENV:-production}

WORKDIR ${DEPS_HOME}

# Install Javascript dependencies
COPY yarn.lock ${DEPS_HOME}/yarn.lock
COPY package.json ${DEPS_HOME}/package.json

RUN \
  if [ "${RAILS_ENV}" = "production" ]; then \
    yarn install --frozen-lockfile --production; \
  else \
    yarn install --frozen-lockfile; \
  fi
# End

# ------------------------------------------------------------------------------
# Dependencies stage: Ruby
# ------------------------------------------------------------------------------
FROM ruby:${RUBY_VERSION} AS builder

ARG RAILS_ENV
ENV FREETDS_VERSION=1.4.10
ENV TDS_VERSION=7.3

# Set the correct version of Rubygems
ENV RUBYGEMS_VERSION=3.3.26
RUN gem update --system "${RUBYGEMS_VERSION}"

# Install Ruby dependencies
ENV BUNDLE_GEM_GROUPS=${RAILS_ENV}
ENV BUNDLER_VERSION=2.3.23
ENV DEPS_HOME=/deps

COPY Gemfile ${DEPS_HOME}/Gemfile
COPY Gemfile.lock ${DEPS_HOME}/Gemfile.lock

# Install FreeTDS
# https://github.com/rails-sqlserver/tiny_tds#install
RUN \
  curl --proto "=https" --tlsv1.2 -sSf \
    "https://www.freetds.org/files/stable/freetds-${FREETDS_VERSION}.tar.gz" \
    --output "freetds-${FREETDS_VERSION}.tar.gz" && \
  tar -xvzf "freetds-${FREETDS_VERSION}.tar.gz" && \
  rm "freetds-${FREETDS_VERSION}.tar.gz" && \
  cd "freetds-${FREETDS_VERSION}" && \
  ./configure --prefix=/usr/local --with-tdsver=${TDS_VERSION} && \
  make && make install

# We pin versions because Docker will cache this layer anyway, the only way to update
# is to modify these versions
RUN gem install bundler --version "${BUNDLER_VERSION}"
RUN bundle _${BUNDLER_VERSION}_ config set frozen "true"
RUN bundle _${BUNDLER_VERSION}_ config set no-cache "true"
RUN bundle _${BUNDLER_VERSION}_ config set with "${BUNDLE_GEM_GROUPS}"

WORKDIR ${DEPS_HOME}

RUN \
  if [ "${RAILS_ENV}" = "production" ]; then \
      bundle _${BUNDLER_VERSION}_ config set without "linting"; \
  fi
RUN bundle _${BUNDLER_VERSION}_ install --retry=10 --jobs=4
# End

# ------------------------------------------------------------------------------
# Application stage
# ------------------------------------------------------------------------------
FROM ruby:${RUBY_VERSION} AS application

ARG RAILS_ENV

ENV USER=rails
ENV UID=1000
ENV GID=1000
ENV APP_ROOT=/srv/
ENV APP_HOME=${APP_ROOT}app
ENV DEPS_HOME=/deps
ENV RAILS_ENV=${RAILS_ENV:-production}
ENV GEM_PATH=${GEM_HOME}

# Set up non-root user for running the service
RUN groupadd --system --gid ${UID} ${USER} && \
    useradd rails --uid ${UID} --gid ${UID} --create-home --shell /bin/bash

# Refresh packages
RUN apt-get update && apt-get upgrade -y

# Cleanup apt cache
RUN rm -rf /var/cache/apt/archives && rm -rf /var/cache/apt/lists

WORKDIR ${APP_HOME}

COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

# Run and own only the runtime files as a non-root user for security
RUN chown -R ${UID}:${GID} ${APP_ROOT}
USER ${UID}:${GID}

COPY Gemfile ${APP_HOME}/Gemfile
COPY Gemfile.lock ${APP_HOME}/Gemfile.lock
COPY --from=builder /usr/local /usr/local
COPY --from=builder ${GEM_HOME} ${GEM_HOME}
COPY --from=nodejs ${DEPS_HOME}/node_modules ${APP_HOME}/node_modules

# Copy app code (sorted by vague frequency of change for caching)
RUN mkdir -p ${APP_HOME}/log
RUN mkdir -p ${APP_HOME}/tmp

COPY .irbrc ${APP_HOME}/.irbrc
COPY config.ru ${APP_HOME}/config.ru
COPY Rakefile ${APP_HOME}/Rakefile
COPY public ${APP_HOME}/public
COPY storage ${APP_HOME}/storage
COPY vendor ${APP_HOME}/vendor
COPY config ${APP_HOME}/config
COPY lib ${APP_HOME}/lib
COPY db ${APP_HOME}/db
COPY app ${APP_HOME}/app
# End

# Create tmp/pids
RUN mkdir -p tmp/pids

RUN \
  if [ "$RAILS_ENV" = "production" ]; then \
    SECRET_KEY_BASE="secret" \
    bundle _${BUNDLER_VERSION}_ exec rake assets:precompile; \
  fi

# In order to expose the current git sha & time of build in the /healthcheck
# endpoint, pass these values into your deployment script, for example:
# --build-arg CURRENT_GIT_SHA="$GITHUB_SHA" \
# --build-arg TIME_OF_BUILD="$(date -u +'%Y-%m-%dT%H:%M:%SZ')" \
ARG CURRENT_GIT_SHA
ARG TIME_OF_BUILD

ENV CURRENT_GIT_SHA=${CURRENT_GIT_SHA}
ENV TIME_OF_BUILD=${TIME_OF_BUILD}

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 3000

LABEL org.opencontainers.image.source=https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes

CMD ["bundle", "_${BUNDLER_VERSION}_", "exec", "rails", "server"]

# ------------------------------------------------------------------------------
# CI stage
# ------------------------------------------------------------------------------
FROM application AS ci

ARG RAILS_ENV
ENV RAILS_ENV=test

ENV BUNDLER_VERSION=2.3.23

USER root

# Install 'test' dependencies
RUN apt-get update && apt-get install --no-install-recommends -y build-essential ca-certificates firefox-esr gnupg libpq-dev shellcheck;

# Cleanup apt cache
RUN rm -rf /var/cache/apt/archives && rm -rf /var/cache/apt/lists

# Install Geckodriver
# https://github.com/mozilla/geckodriver/releases
# default Geckodriver version
ARG geckodriver_version=0.35.0

RUN \
  curl --proto "=https" --tlsv1.2 -sSf -L \
    "https://github.com/mozilla/geckodriver/releases/download/v${geckodriver_version}/geckodriver-v${geckodriver_version}-linux64.tar.gz" \
    --output "geckodriver-v${geckodriver_version}-linux64.tar.gz" && \
  tar -xvzf "geckodriver-v${geckodriver_version}-linux64.tar.gz" && \
  rm "geckodriver-v${geckodriver_version}-linux64.tar.gz" && \
  chmod +x geckodriver && \
  mv geckodriver* /usr/local/bin;

COPY yarn.lock ${APP_HOME}/yarn.lock
COPY package.json ${APP_HOME}/package.json

# Import NodeJS binaries (NPM, Yarn, NPX)
COPY --from=node:18-slim [ "/usr/local/bin/node", "/usr/local/bin/npm", "/usr/local/bin/npx", "/usr/local/bin/" ]
COPY --from=node:18-slim /opt/**/ /opt/yarn/
COPY --from=node:18-slim /usr/local/lib/ /usr/local/lib/
RUN ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn

COPY .erb-lint* ${APP_HOME}/
COPY script ${APP_HOME}/script
COPY bin ${APP_HOME}/bin
COPY doc ${APP_HOME}/doc
COPY .prettierrc ${APP_HOME}/.prettierrc
COPY .rspec ${APP_HOME}/.rspec
COPY spec ${APP_HOME}/spec

# Copy files you want to lint
COPY README.md ${APP_HOME}/README.md
COPY CHANGELOG.md ${APP_HOME}/CHANGELOG.md

# Install 'Test' dependencies
RUN bundle _${BUNDLER_VERSION}_ config set with "test"
RUN bundle _${BUNDLER_VERSION}_ install --retry=10 --jobs=4

# Run and own only the runtime files as a non-root user for security
RUN chown -R ${UID}:${GID} ${APP_ROOT}
USER ${UID}:${GID}

#end
