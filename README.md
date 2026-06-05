# Deployment Recipes

If you're looking for tooling to deploy OpenCHAMI, this is not, in fact, the
repo you're looking for!

## What is this repo?

The _deployment-recipes_ repo you've arrived at represents the initial work by
LANL and NERSC to deploy OpenCHAMI. Neither of those organizations currently
use it to deploy OpenCHAMI.

## Why is this repo now archived?

Earlier tutorial articles linked to this repo because it _was_ something you
could use to get basic familiarity with deploying OpenCHAMI services if you
didn't have an active deployment.

This has given the impression that it's _the_ standard way to deploy OpenCHAMI,
but it isn't. It hasn't been for some time, and the supporting services it uses
(Hydra, OPAAL, etc.) aren't standard or recommended supporting services,
they're things some OpenCHAMI users happened to work with in the past.

## What other options are there?

### Podman Quadlets

https://github.com/OpenCHAMI/release/ has [Podman
Quadlet](https://www.redhat.com/en/blog/quadlet-podman) units available in
RPMs.

As of June 2026, this is the repo used in the OpenCHAMI [installation
tutorial](https://openchami.org/docs/tutorial/).

TODO: further content from LANL re their Quadlets deployments?

### Kubernetes

https://github.com/OpenCHAMI/kube-deploy/ has
[Kustomizations](https://kustomize.io/) and
[ArgoCD](https://argo-cd.readthedocs.io/en/stable/) Applications to deploy
OpenCHAMI services as Kubernetes workloads.

https://github.com/OpenCHAMI/openchami-operator has a [Kubernetes
operator](https://operatorframework.io/) to manage OpenCHAMI services.

TODO: LANL maturity level info for the operator.

## Where should I go if I have further questions?

Please check with the OpenCHAMI TSC [in our community
Slack](https://openchami.org/slack).
