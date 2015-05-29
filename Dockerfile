FROM johnsca/charmbox

MAINTAINER Charles Butler <charles.butler@canonical.com>

RUN apt-get update
RUN apt-get install -y curl git mercurial make binutils bison gcc build-essential
RUN apt-get upgrade -y
ADD install-gvm.sh /tmp/install-gvm.sh
RUN /tmp/install-gvm.sh
run sudo -u ubuntu /bin/bash -c 'ssh-keygen -t rsa -N "" -f /home/ubuntu/.ssh/id_rsa'

ENV JUJU_CI_ENV=aws-kubes-ci
ADD kubes-ci-run.sh /kubes-ci-run.sh


ENTRYPOINT

RUN chown -R ubuntu:ubuntu /home/ubuntu/.juju
CMD sudo -u ubuntu /bin/bash -c "/kubes-ci-run.sh"
