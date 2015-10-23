FROM ubuntu:14.04

RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN apt-get update; apt-get -y upgrade; apt-get clean

RUN apt-get install -y git curl wget tar make; apt-get clean

RUN apt-get install -y sqlite3 libsqlite3-dev; apt-get clean

RUN apt-get install -y mysql-client libmysqlclient-dev; apt-get clean

RUN apt-get install -y postgresql-9.3 postgresql-client-9.3 libpq-dev; apt-get clean

RUN apt-get install -y jq; apt-get clean

# chruby
RUN mkdir /tmp/chruby && \
    cd /tmp && \
    curl https://codeload.github.com/postmodern/chruby/tar.gz/v0.3.9 | tar -xz && \
    cd /tmp/chruby-0.3.9 && \
    sudo ./scripts/setup.sh && \
    rm -rf /tmp/chruby

# ruby-install
RUN mkdir /tmp/ruby-install && \
    cd /tmp && \
    curl https://codeload.github.com/postmodern/ruby-install/tar.gz/v0.5.0 | tar -xz && \
    cd /tmp/ruby-install-0.5.0 && \
    sudo make install && \
    rm -rf /tmp/ruby-install

# ruby
RUN ruby-install ruby 2.1.2

# Install Bundler, Bosh CLI, and CPI Dependencies
RUN /bin/bash -l -c "source /etc/profile.d/chruby.sh ;  \
                     chruby 2.1.2 ;                     \
                     gem update --system ; \
                     gem install bundler bosh_cli --no-ri --no-rdoc ; \
                     cd /tmp ; \
                     git clone https://github.com/cloudfoundry-incubator/bosh-vsphere-cpi-release.git ; \
                     cd bosh-vsphere-cpi-release/src/vsphere_cpi ; \
                     bundle install"
