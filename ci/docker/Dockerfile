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
      rsync \
      sshpass \
      sshuttle \
      tar \
      wget && \
    rm -rf /var/lib/apt/lists/*

ENV RUBY_VERSION=2.6.5

COPY ruby-install /work/ruby-install/

RUN apt-get update && \
    /work/ruby-install/bin/ruby-install \
      -c --system ruby $RUBY_VERSION -- --disable-install-doc && \
    rm -rf /var/lib/apt/lists/* && \
    gem install bundler --no-document

RUN cd /tmp && \
    wget -nv https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-6.4.1-linux-amd64 && \
    ( \
      echo 756d8e403f1d349ef3766d28980379c24da6212fa45dcf296c0519d4ec54d66a bosh-cli-6.4.1-linux-amd64 | \
      sha256sum -c - \
    ) && \
    install -Dm755 bosh-cli-6.4.1-linux-amd64 /usr/local/bin/bosh && \
    rm -f bosh-cli-6.4.1-linux-amd64
