FROM jujusolutions/charmbox

MAINTAINER Charles Butler <charles.butler@canonical.com>

ENV JUJU_CI_ENV=aws

RUN apt-get update
RUN apt-get install -y curl git mercurial make binutils bison gcc build-essential juju juju-quickstart juju-local
RUN apt-get upgrade -y
ADD install-gvm.sh /tmp/install-gvm.sh
RUN /tmp/install-gvm.sh

ADD kubes-ci-run.sh /kubes-ci-run.sh

ADD requires/ssh /home/ubuntu/.ssh
ADD requires/juju /home/ubuntu/.juju

ENTRYPOINT
CMD sudo -u ubuntu /bin/bash -c "/kubes-ci-run.sh"
