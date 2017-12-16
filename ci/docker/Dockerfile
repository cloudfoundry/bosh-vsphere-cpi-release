FROM ubuntu:14.04

ENV LANG C.UTF-8

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    git curl wget tar make \
    jq realpath && \
    apt-get clean

ENV RUBY_VERSION=2.4.2 GOLANG_VERSION=1.8.3

COPY ruby-install /work/ruby-install/

RUN /work/ruby-install/bin/ruby-install --system ruby $RUBY_VERSION -- --disable-install-rdoc

# Install Bundler
RUN gem install bundler --no-ri --no-rdoc

# Install Golang
RUN cd /tmp && \
    wget -nv https://storage.googleapis.com/golang/go$GOLANG_VERSION.linux-amd64.tar.gz && \
    ( \
        echo '1862f4c3d3907e59b04a757cfda0ea7aa9ef39274af99a784f5be843c80c6772 go1.8.3.linux-amd64.tar.gz' | \
        sha256sum -c - \
    ) && \
    tar -C /usr/local -xzf go*.tar.gz && \
    rm go*.tar.gz

RUN mkdir -p /opt/go
ENV GOPATH /opt/go
ENV PATH /usr/local/go/bin:/opt/go/bin:$PATH
