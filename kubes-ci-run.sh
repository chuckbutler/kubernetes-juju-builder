#!/bin/bash

set -ex

export HOME=/home/ubuntu
export KUBERNETES_PROVIDER=juju
. /home/ubuntu/.gvm/scripts/gvm

git clone https://github.com/GoogleCloudPlatform/kubernetes.git $HOME/kubernetes
sudo chown -R ubuntu:ubuntu $HOME/.ssh
sudo chown -R ubuntu:ubuntu $HOME/.juju


cd $HOME/kubernetes

gvm use  go1.4 && \
make all WHAT=cmd/kubectl && \
cluster/kube-up.sh \

