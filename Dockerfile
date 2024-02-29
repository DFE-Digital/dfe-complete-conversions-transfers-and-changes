# ------------------------------------------------------------------------------
# Base stage
# ------------------------------------------------------------------------------
FROM ruby:3.1.4-bullseye AS base

# setup env
ENV APP_HOME /srv/app
ENV DEPS_HOME /deps

# RAILS_ENV defaults to production
ARG RAILS_ENV
ENV RAILS_ENV ${RAILS_ENV:-production}
ENV NODE_ENV ${RAILS_ENV:-production}

# Install basics
#
RUN apt-get update && apt-get install --no-install-recommends -y build-essential libpq-dev ca-certificates curl gnupg

# Setup Node installation
# https://github.com/nodesource/distributions#installation-instructions
#
# depdends on ca-certificates, curl and gnupg
#
ENV NODE_MAJOR=18

RUN mkdir -p /etc/apt/keyrings/ && curl --tlsv1.2 -sSf "https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key" | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main" \
| tee /etc/apt/sources.list.d/nodesource.list

# Setup Yarn installation
# https://classic.yarnpkg.com/lang/en/docs/install/#debian-stable
#
RUN curl --tlsv1.2 -sSf "https://dl.yarnpkg.com/debian/pubkey.gpg" | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install --no-install-recommends -y nodejs yarn

# Install 'test' dependencies
RUN \
  if [ "${RAILS_ENV}" = "test" ]; then \
    apt-get install --no-install-recommends -y firefox-esr shellcheck; \
  fi

# Install FreeTDS
# https://github.com/rails-sqlserver/tiny_tds#install
# default FreeTDS version
ARG freetds_version=1.1.24
RUN \
  curl --tlsv1.2 -sSf "http://www.freetds.org/files/stable/freetds-${freetds_version}.tar.gz" --output "freetds-${freetds_version}.tar.gz" && \
  tar -xvzf "freetds-${freetds_version}.tar.gz" && \
  rm "freetds-${freetds_version}.tar.gz" && \
  cd "freetds-${freetds_version}" && \
  ./configure --prefix=/usr/local --with-tdsver=7.3 && \
  make && make install

# Install Geckodriver
# https://github.com/mozilla/geckodriver/releases
# default Geckodriver version
ARG gecko_driver_version=0.34.0

RUN \
  if [ "${RAILS_ENV}" = "test" ]; then \
    wget --secure-protocol=TLSv1_2 --max-redirect=1 "https://github.com/mozilla/geckodriver/releases/download/v${gecko_driver_version}/geckodriver-v${gecko_driver_version}-linux64.tar.gz" && \
    tar -xvzf "geckodriver-v${gecko_driver_version}-linux64.tar.gz" && \
    rm "geckodriver-v${gecko_driver_version}-linux64.tar.gz" && \
    chmod +x geckodriver && \
    mv geckodriver* /usr/local/bin; \
  fi

RUN apt-get clean && rm -rf /var/cache/apt/archives

# ------------------------------------------------------------------------------
# Dependencies stage
# ------------------------------------------------------------------------------
FROM base AS dependencies

WORKDIR ${DEPS_HOME}

# Install Ruby dependencies
ENV BUNDLE_GEM_GROUPS ${RAILS_ENV}

COPY Gemfile ${DEPS_HOME}/Gemfile
COPY Gemfile.lock ${DEPS_HOME}/Gemfile.lock

# We pin versions because Docker will cache this layer anyway, the only way to update
# is to modify these versions
RUN gem update --system 3.3.26
RUN gem install bundler --version 2.3.23
RUN bundle config set frozen "true"
RUN bundle config set no-cache "true"
RUN bundle config set with "${BUNDLE_GEM_GROUPS}"
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
COPY .eslintignore ${APP_HOME}/.eslintignore
COPY .eslintrc.json ${APP_HOME}/.eslintrc.json
COPY .prettierignore ${APP_HOME}/.prettierignore
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
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails ${APP_HOME}
USER 1000:1000

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server"]
