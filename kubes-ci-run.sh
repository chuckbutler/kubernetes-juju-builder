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

# Revert the SwaggerUI commit
git config --global user.email "ci@dasroot.net"
git config --global user.name "dasroot ci"

set +e
git revert dba914268c23b315cffd42bed00c5d9b6d769287 --no-edit -m 1
git commit -am "revert swagger ui"
set -e

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
