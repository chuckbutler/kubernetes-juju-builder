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
set +e
cluster/kube-up.sh
# Cache the return code of the build, and ultimately return that
BUILDRUN=$?

echo "Please implement further validation here - deploy a workload, benchmark, something awesome"

cluster/kube-down.sh
echo "Forcing destroy of env - just to be safe"
JENV=$(juju env)
juju destroy-environment $JENV -y --force

echo "Test run complete"

exit $BUILDRUN
