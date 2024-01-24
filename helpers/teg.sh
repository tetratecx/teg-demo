#!/usr/bin/env bash
#
# Helper script to manage Tetrate Envoy Gateway (TEG).

HELPERS_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")") ;
# shellcheck source=/dev/null
source "${HELPERS_DIR}/print.sh" ;


# This function installs tetrate envoy gateway.
#   args:
#     (1) json config
function teg_helm_install() {
  [[ -z "${1}" ]] && print_error "Please provide json config as 1st argument" && return 2 || local json_config="${1}" ;

  local chart; chart=$(echo "${json_config}" | jq -r '.chart') ;
  local kubeconfig_file; kubeconfig_file=$(echo "${json_config}" | jq -r '.kubeconfig_file') ;
  local namespace; namespace=$(echo "${json_config}" | jq -r '.namespace') ;
  local release_name; release_name=$(echo "${json_config}" | jq -r '.release_name') ;
  local version; version=$(echo "${json_config}" | jq -r '.version') ;

  print_info "Going to install (or upgrade) Tetrate Envoy Gateway (TEG)" ;
  helm upgrade --install "${release_name}" "${chart}" \
    --create-namespace \
    --kubeconfig "${kubeconfig_file}" \
    --namespace "${namespace}" \
    --version "${version}" ;
}

# This function uninstalls tetrate envoy gateway.
#   args:
#     (1) json config
function teg_helm_uninstall() {
 [[ -z "${1}" ]] && print_error "Please provide json config as 1st argument" && return 2 || local json_config="${1}" ;

  local kubeconfig_file; kubeconfig_file=$(echo "${json_config}" | jq -r '.kubeconfig_file') ;
  local namespace; namespace=$(echo "${json_config}" | jq -r '.namespace') ;
  local release_name; release_name=$(echo "${json_config}" | jq -r '.release_name') ;

  print_info "Going to uninstall Tetrate Envoy Gateway (TEG)" ;
  helm uninstall "${release_name}" \
    --kubeconfig "${kubeconfig_file}" \
    --namespace "${namespace}" ;
}
