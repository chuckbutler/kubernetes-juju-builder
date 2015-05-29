#!/bin/bash

set -ex

export HOME=/home/ubuntu
export KUBERNETES_PROVIDER=juju
. /home/ubuntu/.gvm/scripts/gvm

git clone https://github.com/GoogleCloudPlatform/kubernetes.git $HOME/kubernetes
sudo chown -R ubuntu:ubuntu $HOME/kubernetes

if [ -f '/tmp/juju-credentials.tar.gz' ]; then
    sudo cp /tmp/juju-credentials.tar.gz .
    sudo chown ubuntu:ubuntu juju-credentials.tar.gz
    mkdir -p .juju
    tar xvfz juju-credentials.tar --strip-components=1 -C .juju

    # Randomly, it seems, the .juju directory loses permissions
    sudo chown -R ubuntu:ubuntu $HOME/.juju
fi


if [ ! -f '/home/ubuntu/juju/environments.yaml' ]; then
    echo "No environment configuration found, exiting"
    exit 1
fi

juju switch $JUJU_CI_ENV

# Forcibly destroy the environment, because things happen and stuff
# gets inexplicably stuck when jobs go awry
juju destroy-environment $JUJU_CI_ENV --force || true

cd $HOME/kubernetes

# Allow failure so we always reach cleanup
set +e

gvm use  go1.4 && \
make all WHAT=cmd/kubectl && \
cluster/kube-up.sh \

juju destroy-environment $JUJU_CI_ENV -y --force || true

# Our credentials are ephemeral, so remove them
rm -rf ~/.juju


