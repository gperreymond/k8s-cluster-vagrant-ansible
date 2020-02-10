#!/bin/bash
# kubectl-delete_all is a utility to delete all objects in the namespace.

[[ -n "$DEBUG" ]] && set -x

set -eou pipefail

exec kubectl delete "$(kubectl api-resources --namespaced=true --verbs=delete -o name | tr "\n" "," | sed -e 's/,$//')" --all "$@"
