FROM ubuntu:14.04

ENV LANG C.UTF-8

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    git curl wget tar make \
    jq realpath && \
    apt-get clean

ENV RUBY_INSTALL_VERSION=0.6.1 RUBY_VERSION=2.4.2 GOLANG_VERSION=1.8.3

# Import Postmodern PGP key
RUN wget -nv https://raw.github.com/postmodern/postmodern.github.io/master/postmodern.asc && \
   gpg --import postmodern.asc && \
   gpg --fingerprint 0xB9515E77 | grep 'Key fingerprint = 04B2 F3EA 6541 40BC C7DA  1B57 54C3 D9E9 B951 5E77' && \
   if [ "$?" != "0" ]; then echo "Invalid PGP key!"; exit 1; fi

# Install ruby-install
RUN cd /tmp && \
   wget -nv -O ruby-install-$RUBY_INSTALL_VERSION.tar.gz https://github.com/postmodern/ruby-install/archive/v$RUBY_INSTALL_VERSION.tar.gz && \
   wget -nv https://raw.github.com/postmodern/ruby-install/master/pkg/ruby-install-$RUBY_INSTALL_VERSION.tar.gz.asc && \
   gpg --verify ruby-install-$RUBY_INSTALL_VERSION.tar.gz.asc ruby-install-$RUBY_INSTALL_VERSION.tar.gz && \
   tar -xzvf ruby-install-$RUBY_INSTALL_VERSION.tar.gz && \
   cd ruby-install-$RUBY_INSTALL_VERSION/ && \
   sudo make install && \
   rm -rf /tmp/ruby-install-$RUBY_INSTALL_VERSION && rm /tmp/*

# Install Ruby
RUN ruby-install --system ruby $RUBY_VERSION -- --disable-install-rdoc

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
