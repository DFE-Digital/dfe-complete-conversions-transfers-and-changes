

# Base devcontainer image
#
# https://github.com/devcontainers/images/tree/main/src/ruby
FROM mcr.microsoft.com/devcontainers/ruby:3.4-bookworm

ARG USERNAME=complete
ARG USER_UID=1001
ARG USER_GID=$USER_UID
ENV NODE_MAJOR=18

# Install build dependencies
RUN apt-get update && apt-get install --no-install-recommends -y build-essential ca-certificates curl gnupg libpq-dev firefox-esr

# Setup Node installation
# https://github.com/nodesource/distributions#installation-instructions
#
# depends on ca-certificates, curl and gnupg
#


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

RUN echo "USER_GID: `$USER_GID`"
RUN echo "USERNAME: `$USERNAME`"
RUN echo "USER_ID: `$USER_ID`"

# Set up unprivileged local user
RUN groupadd --gid $USER_GID $USERNAME
RUN groupadd bundler
RUN useradd --uid $USER_UID --gid $USER_GID -m $USERNAME --shell /bin/bash --groups bundler
RUN echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME
RUN chmod 0440 /etc/sudoers.d/$USERNAME

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
  make && make install;

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
    chmod +x geckodriver && mv geckodriver* /usr/local/bin;

# Set unprivileged user as default user
USER $USERNAME

ENV DEVCONTAINER=true
