FROM ubuntu:18.04 AS build-stage
MAINTAINER Mischa ter Smitten <mtersmitten@oefenweb.nl>

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y wget perl-modules python-minimal python-yaml rpm dpkg fakeroot php-cli libtime-hr-perl && \
  apt-get clean

COPY . /data
WORKDIR /data
RUN bash build/build.sh $PWD __GITHUB_RUN_ID__

FROM scratch AS export-stage
COPY --from=build-stage /opt/PKGS/percona-*_all.deb .
COPY --from=build-stage /opt/PKGS/percona-*.noarch.rpm .
