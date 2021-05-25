FROM harbor-repo.vmware.com/dockerhub-proxy-cache/library/ubuntu:18.04

ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      git \
      jq \
      make \
      netcat-openbsd \
      openssh-client \
      openvpn \
      rsync \
      sshpass \
      sshuttle \
      tar \
      wget && \
    rm -rf /var/lib/apt/lists/*

ENV RUBY_VERSION=2.6.5 GOLANG_VERSION=1.16.4

COPY ruby-install /work/ruby-install/

RUN apt-get update && \
    /work/ruby-install/bin/ruby-install \
      -c --system ruby $RUBY_VERSION -- --disable-install-doc && \
    rm -rf /var/lib/apt/lists/* && \
    gem install bundler --no-document

# Install Golang
RUN cd /tmp && \
    wget -nv https://storage.googleapis.com/golang/go$GOLANG_VERSION.linux-amd64.tar.gz && \
    ( \
        echo '7154e88f5a8047aad4b80ebace58a059e36e7e2e4eb3b383127a28c711b4ff59 go1.16.4.linux-amd64.tar.gz' | \
        sha256sum -c - \
    ) && \
    tar -C /usr/local -xzf go*.tar.gz && \
    rm go*.tar.gz

RUN mkdir -p /opt/go
ENV GOPATH /opt/go
ENV PATH /usr/local/go/bin:/opt/go/bin:$PATH

RUN cd /tmp && \
    wget -nv https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-6.4.1-linux-amd64 && \
    ( \
      echo 756d8e403f1d349ef3766d28980379c24da6212fa45dcf296c0519d4ec54d66a bosh-cli-6.4.1-linux-amd64 | \
      sha256sum -c - \
    ) && \
    install -Dm755 bosh-cli-6.4.1-linux-amd64 /usr/local/bin/bosh && \
    rm -f bosh-cli-6.4.1-linux-amd64
