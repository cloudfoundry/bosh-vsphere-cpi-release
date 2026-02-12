# To build

# docker buildx build --platform=linux/arm64,linux/amd64 --load -t bosh/vsphere-vcpi .
# docker run -it --rm bosh/vsphere-vcpi

FROM ghcr.io/cloudfoundry/bosh/golang-release

LABEL org.opencontainers.image.authors="bosh-ecosystem@groups.vmware.com"

ENV LANG=C.UTF-8
ENV RUBY_INSTALL_VERSION=0.9.3

# TARGETARCH is a "magic" ARG that can be either amd64 or arm64
ARG TARGETARCH
ARG BOSH_CLI_VERSION

ADD .ruby-version /tmp/.ruby-version

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      git \
      git-lfs \
      jq \
      make \
      neovim \
      netcat-openbsd \
      openssh-client \
      openvpn \
      rsync \
      sshpass \
      sshuttle \
      tar \
      wget

RUN wget -O ruby-install-${RUBY_INSTALL_VERSION}.tar.gz https://github.com/postmodern/ruby-install/archive/v${RUBY_INSTALL_VERSION}.tar.gz && \
  tar -xzvf ruby-install-${RUBY_INSTALL_VERSION}.tar.gz && \
  cd ruby-install-${RUBY_INSTALL_VERSION}/ && \
  make install && \
  rm -rf ruby-install-${RUBY_INSTALL_VERSION}*

RUN apt-get update && \
  /usr/local/bin/ruby-install \
  -c --system ruby "$(cat /tmp/.ruby-version)" -- --disable-install-doc && \
  rm -rf /var/lib/apt/lists/* && \
  gem install bundler --no-document

# BOSH CLI
RUN curl -sL https://github.com/cloudfoundry/bosh-cli/releases/download/v${BOSH_CLI_VERSION}/bosh-cli-${BOSH_CLI_VERSION}-linux-amd64 \
    > /usr/local/bin/bosh \
    && chmod +x /usr/local/bin/bosh
