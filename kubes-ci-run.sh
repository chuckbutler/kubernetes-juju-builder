#!/bin/bash

set -ex
apt-get install -y curl git mercurial make binutils bison gcc build-essential

# Fetch GVM
curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer -o /tmp/gvm-installer
chmod +x /tmp/gvm-installer


# Run command as Ubuntu User
/tmp/gvm-installer
. $HOME/.gvm/scripts/gvm
gvm install go1.4

export KUBERNETES_PROVIDER=juju


git clone https://github.com/GoogleCloudPlatform/kubernetes.git kubernetes

cd kubernetes

gvm use  go1.4 && \
make all WHAT=cmd/kubectl && \
set +e
juju bootstrap
cluster/kube-up.sh
# Cache the return code of the build, and ultimately return that
BUILDRUN=$?

echo "Please implement further validation here - deploy a workload, benchmark, something awesome"

cluster/kube-down.sh
echo "Forcing destroy of env - just to be safe"
juju destroy-environment $CIENV -y --force

echo "Test run complete"

exit $BUILDRUN
