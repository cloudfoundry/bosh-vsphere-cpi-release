# To build

# docker build -t bosh/vsphere-vcpi .
# docker push bosh/vsphere-vcpi
# docker run -it --rm bosh/vsphere-vcpi

FROM harbor-repo.vmware.com/dockerhub-proxy-cache/library/ubuntu:22.04

LABEL org.opencontainers.image.authors="bosh-ecosystem@groups.vmware.com"

ENV LANG C.UTF-8

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

ENV RUBY_VERSION=3.1.2 GOLANG_VERSION=1.18

RUN wget -O ruby-install-0.8.3.tar.gz https://github.com/postmodern/ruby-install/archive/v0.8.3.tar.gz && \
  tar -xzvf ruby-install-0.8.3.tar.gz && \
  cd ruby-install-0.8.3/ && \
  make install && \
  rm -rf ruby-install-0.8.3*

RUN apt-get update && \
  /usr/local/bin/ruby-install \
  -c --system ruby $RUBY_VERSION -- --disable-install-doc && \
  rm -rf /var/lib/apt/lists/* && \
  gem install bundler --no-document

# Install Golang
RUN cd /tmp && \
  wget -nv https://storage.googleapis.com/golang/go$GOLANG_VERSION.linux-amd64.tar.gz && \
  ( \
  echo 'e85278e98f57cdb150fe8409e6e5df5343ecb13cebf03a5d5ff12bd55a80264f go1.18.linux-amd64.tar.gz' | \
  sha256sum -c - \
  ) && \
  tar -C /usr/local -xzf go*.tar.gz && \
  rm go*.tar.gz

RUN mkdir -p /opt/go
ENV GOPATH /opt/go
ENV PATH /usr/local/go/bin:/opt/go/bin:$PATH

RUN cd /tmp && \
  wget -nv https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-6.4.17-linux-amd64 && \
  ( \
  echo d0917d3ad0ff544a4c69a7986e710fe48e8cb2207717f77db31905d639e28c18 bosh-cli-6.4.17-linux-amd64 | \
  sha256sum -c - \
  ) && \
  install -Dm755 bosh-cli-6.4.17-linux-amd64 /usr/local/bin/bosh && \
  rm -f bosh-cli-6.4.17-linux-amd64

# Install fasd, used by Luan's nvim config
RUN mkdir ~/workspace; \
  cd ~/workspace; \
  git clone https://github.com/clvv/fasd.git; \
  cd fasd; \
  sudo make install; \
  echo 'eval "\$(fasd --init posix-alias zsh-hook)"' >> ~/.zshrc; \
  echo 'alias z='fasd_cd -d'     # cd, same functionality as j in autojump' >> ~/.zshrc \
  EOF

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
