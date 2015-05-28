FROM johnsca/charmbox

MAINTAINER Charles Butler <charles.butler@canonical.com>

RUN apt-get update
RUN apt-get install -y curl git mercurial make binutils bison gcc build-essential
RUN apt-get upgrade -y
ADD install-gvm.sh /tmp/install-gvm.sh
RUN /tmp/install-gvm.sh

RUN sudo -u ubuntu /bin/bash -c "mkdir /home/ubuntu/kubernetes"
VOLUME /home/ubuntu/kubernetes

ENV JUJU_CI_ENV=aws-kubes-ci
 
ADD kubes-ci-run.sh /kubes-ci-run.sh
ENTRYPOINT
CMD sudo -u ubuntu /bin/bash -c "/kubes-ci-run.sh"

