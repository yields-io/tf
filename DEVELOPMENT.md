# Development

This repository contains the [Terraform](https://www.terraform.io/) specs for creating a
[Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine) cluster.

## Setup

Setup instructions are documented in the [`README`](README.md).

GitHub Actions requires a `GH_TOKEN` [secret](https://docs.github.com/en/free-pro-team@latest/actions/reference/encrypted-secrets) for creating releases.

### pre-commit

Add a [`pre-commit`](https://git-scm.com/docs/githooks#_pre_commit) hook in your local checkout
(`${PWD}/.git/hooks/pre-commit`) with the a `terraform validate` command:
```bash
docker run --rm -t \
    -u 1000 \
    --name terraform \
    -v ${PWD}:/workspace/source \
    -w /workspace/source \
    hashicorp/terraform:0.13.3 init

docker run --rm -t \
    -u 1000 \
    --name terraform \
    -v ${PWD}:/workspace/source \
    -w /workspace/source \
    hashicorp/terraform:0.13.3 validate
```

**Note**: the release pipeline will fail if the specs are invalid.

## Commit style guide

We use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/). The `CHANGELOG`
is created from the commit messages.

## Versioning

We use [Semantic Versioning](https://semver.org/) for releases.
