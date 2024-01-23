#!/usr/bin/env bash
#
# Helper script to manage AWS infra.

HELPERS_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")") ;
# shellcheck source=/dev/null
source "${HELPERS_DIR}/print.sh" ;
