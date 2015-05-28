#!/bin/bash

set -ex

export HOME=/home/ubuntu
export KUBERNETES_PROVIDER=juju
. /home/ubuntu/.gvm/scripts/gvm

chown -R ubuntu:ubuntu $HOME/kubernetes
cd $HOME/kubernetes

/bin/bash -c 'ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa'

gvm use  go1.4 && \
make all WHAT=cmd/kubectl && \
cluster/kube-up.sh \



