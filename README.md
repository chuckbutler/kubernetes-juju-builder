## Canary builder for Kubernetes w/ Juju

The Juju team landed code in upstream [Kubernetes](https://github.com/googlecloudplatform/kubernetes/)
repository, and we wanted a tell-tale way to discover if we were still inherently
working or broken based on the commit stream that occurs over a week.


### What it does today

- [x] Checkout a fresh copy of Go v1.4
- [x] Build kubernetes
- [x] bootstrap's the configured host
- [x] Deploys the kubernetes core infrastructure as defined in `cluster/juju`
- [x] Basic validation via kube-verify.sh

### What it will do in the near future

- [ ] Run e2e for conformance
- [ ] Monitor the Kubernetes upstream repository and rebuild when passing CI results
are merged in
- [ ] Report through `scrappie` the friendly bot for #systemzoo when things are broken
- [ ] Run a daily litmus build, and provide reporting on the cloud deployed
- [ ] Verify with a basic workload deployment + validation

### Who should you contact about this?

I'm currently a one-man-show on the validations of the kubernetes standup
with this script. If anything is broken please file a bug on the [issue tracker](https://github.com/chuckbutler/kubernetes-juju-builder/issues)
of this project.

