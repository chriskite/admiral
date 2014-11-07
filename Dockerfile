# Use phusion/baseimage as base image. To make your builds
# reproducible, make sure you lock down to a specific version, not
# to `latest`! See
# https://github.com/phusion/baseimage-docker/blob/master/Changelog.md
# for a list of version numbers.
FROM phusion/baseimage:0.9.15

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN apt-get update
RUN apt-get install -qqy --force-yes build-essential curl git wget zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev apt-transport-https ca-certificates lxc iptables

# Adapted from github.com/jpetazzo/dind
# Install Docker from Docker Inc. repositories.
RUN echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9 \
  && apt-get update -qq \
  && apt-get install -qqy lxc-docker
# Define additional metadata for our image.
VOLUME /var/lib/docker

# Install rbenv and ruby-build
RUN git clone https://github.com/sstephenson/rbenv.git /root/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /root/.rbenv/plugins/ruby-build
RUN ./root/.rbenv/plugins/ruby-build/install.sh
ENV PATH /root/.rbenv/bin:$PATH
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh # or /etc/profile
RUN echo 'eval "$(rbenv init -)"' >> /root/.bashrc

# Install multiple versions of ruby
ENV CONFIGURE_OPTS --disable-install-doc
ADD .ruby-version /root/versions.txt
RUN xargs -L 1 rbenv install < /root/versions.txt

# Install Bundler for each version of ruby
RUN echo 'gem: --no-rdoc --no-ri' >> /.gemrc
RUN bash -l -c 'for v in $(cat /root/versions.txt); do rbenv global $v; gem install bundler; done'

# install admiral
RUN mkdir /admiral
WORKDIR /admiral
ADD Gemfile /admiral/
ADD Gemfile.lock /admiral/
RUN /bin/bash -l -c "bundle install"

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Disable SSH
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

# Install etcd and etcdctl (used for testing)
RUN wget https://github.com/coreos/etcd/releases/download/v0.4.6/etcd-v0.4.6-linux-amd64.tar.gz
RUN tar -C /opt/ -xzf etcd-v0.4.6-linux-amd64.tar.gz && mv /opt/etcd* /opt/etcd
RUN ln -s /opt/etcd/etcd /bin/etcd && ln -s /opt/etcd/etcdctl /bin/etcdctl

# Install the docker wrapper as a runit service
ADD bin/wrapdocker.sh /etc/service/wrapdocker/run

ADD bin /admiral/bin
ADD spec /admiral/spec
ADD lib /admiral/lib


