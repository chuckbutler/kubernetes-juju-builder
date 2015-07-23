#!/bin/bash

set -ex
apt-get update
apt-get install -y curl git mercurial make binutils bison gcc build-essential juju juju-quickstart juju-local

# Fetch GVM
curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer -o /tmp/gvm-installer
chmod +x /tmp/gvm-installer

export HOME=/home/ubuntu

# Run command as Ubuntu User
sudo -u ubuntu /tmp/gvm-installer
sudo -u ubuntu /bin/bash -c "source /home/ubuntu/.gvm/scripts/gvm && gvm install go1.4"

export HOME=/home/ubuntu
export KUBERNETES_PROVIDER=juju
. /home/ubuntu/.gvm/scripts/gvm


git clone https://github.com/GoogleCloudPlatform/kubernetes.git $HOME/kubernetes
sudo chown -R ubuntu:ubuntu $HOME/.ssh
sudo chown -R ubuntu:ubuntu $HOME/.juju
juju switch $JUJU_CI_ENV

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
