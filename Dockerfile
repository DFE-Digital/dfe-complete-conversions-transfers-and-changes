# ------------------------------------------------------------------------------
# Base stage
# ------------------------------------------------------------------------------
FROM ruby:3.1.6-bookworm AS base

ENV USER rails
ENV UID 1000
ENV GID 1000

# setup env
ENV APP_ROOT /srv/
ENV APP_HOME ${APP_ROOT}app
ENV DEPS_HOME /deps

# RAILS_ENV defaults to production
ARG RAILS_ENV
ENV RAILS_ENV ${RAILS_ENV:-production}
ENV NODE_ENV ${RAILS_ENV:-production}

# Set up non-root user for running the service
RUN groupadd --system --gid ${UID} ${USER} && \
    useradd rails --uid ${UID} --gid ${UID} --create-home --shell /bin/bash

# Install basics
#
RUN apt-get update && apt-get install --no-install-recommends -y build-essential libpq-dev ca-certificates curl gnupg

# Setup Node installation
# https://github.com/nodesource/distributions#installation-instructions
#
# depends on ca-certificates, curl and gnupg
#
ENV NODE_MAJOR=18

RUN mkdir -p /etc/apt/keyrings/ && curl --tlsv1.2 -sSf "https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key" \
  | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main" \
  | tee /etc/apt/sources.list.d/nodesource.list

# Setup Yarn installation
# https://classic.yarnpkg.com/lang/en/docs/install/#debian-stable
#
RUN curl --proto "=https" --tlsv1.2 -sSf "https://dl.yarnpkg.com/debian/pubkey.gpg" | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install --no-install-recommends -y nodejs yarn

# Install 'test' dependencies
RUN \
  if [ "${RAILS_ENV}" = "test" ]; then \
    apt-get install --no-install-recommends -y firefox-esr shellcheck; \
  fi

RUN apt-get clean && rm -rf /var/cache/apt/archives && rm -rf /var/cache/apt/lists

# Install FreeTDS
# https://github.com/rails-sqlserver/tiny_tds#install
# default FreeTDS version
ARG FREETDS_VERSION=1.4.10
ARG TDS_VERSION=7.3
RUN \
  curl --proto "=https" --tlsv1.2 -sSf \
    "https://www.freetds.org/files/stable/freetds-${FREETDS_VERSION}.tar.gz" \
    --output "freetds-${FREETDS_VERSION}.tar.gz" && \
  tar -xvzf "freetds-${FREETDS_VERSION}.tar.gz" && \
  rm "freetds-${FREETDS_VERSION}.tar.gz" && \
  cd "freetds-${FREETDS_VERSION}" && \
  ./configure --prefix=/usr/local --with-tdsver=${TDS_VERSION} && \
  make && make install

# Install Geckodriver
# https://github.com/mozilla/geckodriver/releases
# default Geckodriver version
ARG geckodriver_version=0.34.0

RUN \
  if [ "${RAILS_ENV}" = "test" ]; then \
    curl --proto "=https" --tlsv1.2 -sSf -L \
      "https://github.com/mozilla/geckodriver/releases/download/v${geckodriver_version}/geckodriver-v${geckodriver_version}-linux64.tar.gz" \
      --output "geckodriver-v${geckodriver_version}-linux64.tar.gz" && \
    tar -xvzf "geckodriver-v${geckodriver_version}-linux64.tar.gz" && \
    rm "geckodriver-v${geckodriver_version}-linux64.tar.gz" && \
    chmod +x geckodriver && \
    mv geckodriver* /usr/local/bin; \
  fi

# ------------------------------------------------------------------------------
# Dependencies stage
# ------------------------------------------------------------------------------
FROM base AS dependencies

WORKDIR ${DEPS_HOME}
RUN chown -R ${UID}:${GID} ${DEPS_HOME}
USER ${UID}:${GID}

# Install Ruby dependencies
ENV BUNDLE_GEM_GROUPS ${RAILS_ENV}

COPY Gemfile ${DEPS_HOME}/Gemfile
COPY Gemfile.lock ${DEPS_HOME}/Gemfile.lock

# We pin versions because Docker will cache this layer anyway, the only way to update
# is to modify these versions
RUN gem update --system 3.3.26
RUN gem install bundler --version 2.3.23
RUN bundle config set frozen "true"
RUN bundle config set no-cache "true"
RUN bundle config set with "${BUNDLE_GEM_GROUPS}"
RUN \
    if [ "${RAILS_ENV}" = "production" ]; then \
        bundle config set without "linting"; \
    fi
RUN bundle install --retry=10 --jobs=4
# End

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
# Application stage
# ------------------------------------------------------------------------------
FROM base AS application

WORKDIR ${APP_HOME}

# Copy dependencies (relying on dependencies using the same base image as this)
COPY --from=dependencies ${DEPS_HOME}/Gemfile ${APP_HOME}/Gemfile
COPY --from=dependencies ${DEPS_HOME}/Gemfile.lock ${APP_HOME}/Gemfile.lock
COPY --from=dependencies ${GEM_HOME} ${GEM_HOME}

COPY --from=dependencies ${DEPS_HOME}/package.json ${APP_HOME}/package.json
COPY --from=dependencies ${DEPS_HOME}/yarn.lock ${APP_HOME}/yarn.lock
COPY --from=dependencies ${DEPS_HOME}/node_modules ${APP_HOME}/node_modules
# End

# Copy app code (sorted by vague frequency of change for caching)
RUN mkdir -p ${APP_HOME}/log
RUN mkdir -p ${APP_HOME}/tmp
RUN mkdir -p ${APP_HOME}/coverage

COPY .irbrc ${APP_HOME}/.irbrc
COPY config.ru ${APP_HOME}/config.ru
COPY Rakefile ${APP_HOME}/Rakefile
COPY script ${APP_HOME}/script
COPY public ${APP_HOME}/public
COPY storage ${APP_HOME}/storage
COPY vendor ${APP_HOME}/vendor
COPY bin ${APP_HOME}/bin
COPY config ${APP_HOME}/config
COPY lib ${APP_HOME}/lib
COPY db ${APP_HOME}/db
COPY app ${APP_HOME}/app
COPY doc ${APP_HOME}/doc
# End

# Copy specs
COPY .prettierrc ${APP_HOME}/.prettierrc
COPY .rspec ${APP_HOME}/.rspec
COPY spec ${APP_HOME}/spec
# End

# Copy files you want to lint
COPY README.md ${APP_HOME}/README.md
COPY CHANGELOG.md ${APP_HOME}/CHANGELOG.md
#end

# Create tmp/pids
RUN mkdir -p tmp/pids

RUN \
  if [ "$RAILS_ENV" = "production" ]; then \
    SECRET_KEY_BASE="secret" \
    bundle exec rake assets:precompile; \
  fi

# In order to expose the current git sha & time of build in the /healthcheck
# endpoint, pass these values into your deployment script, for example:
# --build-arg CURRENT_GIT_SHA="$GITHUB_SHA" \
# --build-arg TIME_OF_BUILD="$(date -u +'%Y-%m-%dT%H:%M:%SZ')" \
ARG CURRENT_GIT_SHA
ARG TIME_OF_BUILD

ENV CURRENT_GIT_SHA ${CURRENT_GIT_SHA}
ENV TIME_OF_BUILD ${TIME_OF_BUILD}

COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

# Run and own only the runtime files as a non-root user for security
RUN chown -R ${UID}:${GID} ${APP_ROOT}
USER ${UID}:${GID}

EXPOSE 3000

LABEL org.opencontainers.image.source=https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes

CMD ["bundle", "exec", "rails", "server"]
