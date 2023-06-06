# To build

# docker buildx build --platform=linux/arm64,linux/amd64 --load -t bosh/vsphere-vcpi .
# docker run -it --rm bosh/vsphere-vcpi

FROM harbor-repo.vmware.com/dockerhub-proxy-cache/library/ubuntu:22.04

LABEL org.opencontainers.image.authors="bosh-ecosystem@groups.vmware.com"

ENV BOSH_VERSION=7.2.3
ENV GOLANG_VERSION=1.20.4
ENV LANG=C.UTF-8
ENV RUBY_INSTALL_VERSION=0.9.0

# TARGETARCH is a "magic" ARG that can be either amd64 or arm64
ARG TARGETARCH

ADD .ruby-version /tmp/.ruby-version

RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  git \
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
  wget \
  zsh \
  \
  && \
  rm -rf /var/lib/apt/lists/*

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

# Golang
RUN cd /tmp && \
  wget -nv https://storage.googleapis.com/golang/go${GOLANG_VERSION}.linux-${TARGETARCH}.tar.gz && \
  ( \
  echo "$(wget -O- https://storage.googleapis.com/golang/go${GOLANG_VERSION}.linux-${TARGETARCH}.tar.gz.sha256) go${GOLANG_VERSION}.linux-${TARGETARCH}.tar.gz" | \
  sha256sum -c - \
  ) && \
  tar -C /usr/local -xzf go*.tar.gz && \
  rm go*.tar.gz

RUN mkdir -p /opt/go
ENV GOPATH /opt/go
ENV PATH /usr/local/go/bin:/opt/go/bin:$PATH

# BOSH CLI
RUN cd /tmp && \
  wget -nv https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-${BOSH_VERSION}-linux-${TARGETARCH} && \
  install -Dm755 bosh-cli-${BOSH_VERSION}-linux-${TARGETARCH} /usr/local/bin/bosh && \
  rm -f bosh-cli-${BOSH_VERSION}-linux-${TARGETARCH}

# Oh My zsh, which is awesome
RUN  echo "" | SHELL=/usr/bin/zsh zsh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; \
  sed -i 's/robbyrussell/agnoster/' ~/.zshrc; \
  echo 'export EDITOR=nvim' >> ~/.zshrc

RUN GOBIN=/usr/local/go/bin \
  /usr/local/go/bin/go install github.com/onsi/ginkgo/v2/ginkgo@latest; \
  /usr/local/go/bin/go install github.com/onsi/ginkgo/v2@latest; \
  /usr/local/go/bin/go install github.com/onsi/gomega/...@latest

# `zsh` is the hot new shell
CMD [ "/usr/bin/zsh" ]
