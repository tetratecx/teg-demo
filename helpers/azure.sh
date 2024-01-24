#!/usr/bin/env bash
#
# Helper script to manage Azure infra.

HELPERS_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")") ;
# shellcheck source=/dev/null
source "${HELPERS_DIR}/print.sh" ;


# Start an azure aks cluster
#   args:
#     (1) json config
function start_aks_cluster {
  [[ -z "${1}" ]] && print_error "Please provide json config as 1st argument" && return 2 || local json_config="${1}" ;

  local cluster_name; cluster_name=$(echo "${json_config}" | jq -r '.cluster_name') ;
  local k8s_version; k8s_version=$(echo "${json_config}" | jq -r '.k8s_version') ;
  local kubeconfig_file; kubeconfig_file=$(echo "${json_config}" | jq -r '.kubeconfig_file') ;
  local location; location=$(echo "${json_config}" | jq -r '.location') ;
  local resourcegroup_name; resourcegroup_name=$(echo "${json_config}" | jq -r '.resourcegroup_name') ;

  if [[ $(az group exists --name "${resourcegroup_name}") == "false" ]]; then
    print_info "Creating resource group ${resourcegroup_name} in location ${location}..." ;
    az group create --name "${resourcegroup_name}" --location "${location}" ;
  else
    print_info "Resource group ${resourcegroup_name} already exists." ;
  fi

  if ! az aks show --resource-group "${resourcegroup_name}" --name "${cluster_name}" &> /dev/null; then
    print_info "Starting AKS cluster ${cluster_name} with k8s version ${k8s_version}..." ;
    az aks create \
      --resource-group "${resourcegroup_name}" \
      --name "${cluster_name}" \
      --node-count 1 \
      --enable-addons monitoring \
      --generate-ssh-keys \
      --kubernetes-version "${k8s_version}" ;
  else
    print_info "AKS cluster ${cluster_name} already exists." ;
  fi

  az aks get-credentials \
    --resource-group "${resourcegroup_name}" \
    --name "${cluster_name}" \
    --file "${kubeconfig_file}" ;
}

# Stop an azure aks cluster
#   args:
#     (1) json config
function stop_aks_cluster {
  [[ -z "${1}" ]] && print_error "Please provide json config as 1st argument" && return 2 || local json_config="${1}" ;

  local cluster_name; cluster_name=$(echo "${json_config}" | jq -r '.cluster_name') ;
  local resourcegroup_name; resourcegroup_name=$(echo "${json_config}" | jq -r '.resourcegroup_name') ;

  if az aks show --resource-group "${resourcegroup_name}" --name "${cluster_name}" &> /dev/null; then
    print_info "Stopping AKS cluster ${cluster_name}..." ;
    az aks stop --name "${cluster_name}" --resource-group "${resourcegroup_name}" ;
  else
    print_error "AKS cluster ${cluster_name} does not exist in resource group ${resourcegroup_name}." ;
    return 1;
  fi
}

# Remove an azure aks cluster
#   args:
#     (1) json config
function remove_aks_cluster {
  [[ -z "${1}" ]] && print_error "Please provide json config as 1st argument" && return 2 || local json_config="${1}" ;

  local cluster_name; cluster_name=$(echo "${json_config}" | jq -r '.cluster_name') ;
  local resourcegroup_name; resourcegroup_name=$(echo "${json_config}" | jq -r '.resourcegroup_name') ;

  if az aks show --resource-group "${resourcegroup_name}" --name "${cluster_name}" &> /dev/null; then
    print_info "Removing AKS cluster ${cluster_name}..." ;
    az aks delete --name "${cluster_name}" --resource-group "${resourcegroup_name}" --yes --no-wait ;
  
    print_info "Deleting resource group ${resourcegroup_name}..." ;
    az group delete --name "${resourcegroup_name}" --yes ;
  else
    print_error "AKS cluster ${cluster_name} does not exist in resource group ${resourcegroup_name}." ;
    return 1;
  fi
}

# Print info an azure aks cluster
#   args:
#     (1) json config
function info_aks_cluster {
  [[ -z "${1}" ]] && print_error "Please provide json config as 1st argument" && return 2 || local json_config="${1}" ;

  local cluster_name; cluster_name=$(echo "${json_config}" | jq -r '.cluster_name') ;
  local kubeconfig_file; kubeconfig_file=$(echo "${json_config}" | jq -r '.kubeconfig_file') ;
  local resourcegroup_name; resourcegroup_name=$(echo "${json_config}" | jq -r '.resourcegroup_name') ;

  print_command "az resource list --resource-group ${resourcegroup_name} --output table" ;
  az resource list --resource-group "${resourcegroup_name}" --output table ;

  print_command "az aks show --resource-group ${resourcegroup_name} --name ${cluster_name} --output table" ;
  az aks show --resource-group "${resourcegroup_name}" --name "${cluster_name}" --output table ;

  print_command "kubectl --kubeconfig ${kubeconfig_file} cluster-info" ;
  kubectl --kubeconfig "${kubeconfig_file}" cluster-info ;

  print_command "kubectl --kubeconfig ${kubeconfig_file} get nodes --output wide" ;
  kubectl --kubeconfig "${kubeconfig_file}" get nodes --output wide ;

  print_command "kubectl --kubeconfig ${kubeconfig_file} get pods --all-namespaces --output wide" ;
  kubectl --kubeconfig "${kubeconfig_file}" get pods --all-namespaces --output wide ;
}