#!/usr/bin/env bash
BASE_DIR="$( cd -- "$(dirname "${0}")" >/dev/null 2>&1 ; pwd -P )" ;

# shellcheck source=/dev/null
source "${BASE_DIR}/helpers/azure.sh" ;
# shellcheck source=/dev/null
source "${BASE_DIR}/helpers/certs.sh" ;
# shellcheck source=/dev/null
source "${BASE_DIR}/helpers/print.sh" ;
# shellcheck source=/dev/null
source "${BASE_DIR}/helpers/teg.sh" ;

ACTION=${1} ;

# This function provides help information for the script.
#
function help() {
  echo "Usage: $0 <command> [options]" ;
  echo "Commands:" ;
  echo "  --infra-up: bring up and configure the instrastructure" ;
  echo "  --infra-down: bring down the instrastructure" ;
  echo "  --infra-info: get infrastructure information" ;
  echo "  --teg-install: install Tetrate Envoy Gateway (TEG)" ;
  echo "  --teg-uninstall: uninstall Tetrate Envoy Gateway (TEG)" ;
  echo "  --scenario-deploy: deploy the scenario" ;
  echo "  --scenario-undeploy: undeploy the scenario" ;
  echo "  --scenario-info: get scenario information" ;
  echo "  --clean: remove the instrastructure" ;
}

# This function brings up the instrastructure.
#
function infra_up() {
  print_info "Going to bring up the infrastructure" ;
  start_aks_cluster "$(jq -c .azure_aks infra.json)" ;
}

# This function brings down the instrastructure.
#
function infra_down() {
  print_info "Going to bring down the infrastructure" ;
  stop_aks_cluster "$(jq -c .azure_aks infra.json)" ;
}

# This function prints info about the instrastructure.
#
function infra_info() {
  print_info "Going to print info about the infrastructure" ;
  info_aks_cluster "$(jq -c .azure_aks infra.json)" ;
}

# This function installs Tetrate Envoy Gateway (TEG).
#
function teg_install() {
  print_info "Going to install Tetrate Envoy Gateway (TEG)" ;
  teg_helm_install "$(jq -c .teg infra.json)" ;
}

# This function uninstalls Tetrate Envoy Gateway (TEG).
#
function teg_uninstall() {
  print_info "Going to uninstall Tetrate Envoy Gateway (TEG)" ;
  teg_helm_uninstall "$(jq -c .teg infra.json)" ;
}

# This function brings up the instrastructure.
#
function scenario_deploy() {
  print_info "Going to deploy the scenario" ;

}

# This function brings down the instrastructure.
#
function scenario_undeploy() {
  print_info "Going to undeploy the scenario" ;

}

# This function prints info about the instrastructure.
#
function scenario_info() {
  print_info "Going to print info about the scenario" ;

}



# This function removes the instrastructure.
#
function clean() {
  print_info "Going to remove the infrastructure" ;
  remove_aks_cluster "$(jq -c .azure_aks infra.json)" ;
}


# Main execution
#
case "${ACTION}" in
  --help)
    help ;
    ;;
  --infra-up)
    print_stage "Going to bring up the infrastructure" ;
    start_time=$(date +%s); infra_up; elapsed_time=$(( $(date +%s) - start_time )) ;
    print_stage "Brought up infrastructure in ${elapsed_time} seconds" ;
    ;;
  --infra-down)
    print_stage "Going to bring down the infrastructure" ;
    start_time=$(date +%s); infra_down; elapsed_time=$(( $(date +%s) - start_time )) ;
    print_stage "Brought down infrastructure in ${elapsed_time} seconds" ;
    ;;
  --infra-info)
    print_stage "Going to print info about the infrastructure" ;
    infra_info ;
    ;;
  --teg-install)
    print_stage "Going to install Tetrate Envoy Gateway (TEG)" ;
    start_time=$(date +%s); teg_install; elapsed_time=$(( $(date +%s) - start_time )) ;
    print_stage "Installed Tetrate Envoy Gateway (TEG) in ${elapsed_time} seconds" ;
    ;;
  --teg-uninstall)
    print_stage "Going to uninstall Tetrate Envoy Gateway (TEG)" ;
    start_time=$(date +%s); teg_uninstall; elapsed_time=$(( $(date +%s) - start_time )) ;
    print_stage "Uninstalled Tetrate Envoy Gateway (TEG) in ${elapsed_time} seconds" ;
    ;;
  --scenario-deploy)
    print_stage "Going to deploy the scenario" ;
    start_time=$(date +%s); scenario_deploy; elapsed_time=$(( $(date +%s) - start_time )) ;
    print_stage "Deployed secenario in ${elapsed_time} seconds" ;
    ;;
  --scenario-undeploy)
    print_stage "Going to undeploy the scenario" ;
    start_time=$(date +%s); scenario_undeploy; elapsed_time=$(( $(date +%s) - start_time )) ;
    print_stage "Undeployed secenario in ${elapsed_time} seconds" ;
    ;;
  --scenario-info)
    print_stage "Going to print info about the scenario" ;
    scenario_info ;
    ;;
  --clean)
    print_stage "Going to remove the infrastructure" ;
    start_time=$(date +%s); clean; elapsed_time=$(( $(date +%s) - start_time )) ;
    print_stage "Removed infrastructure in ${elapsed_time} seconds" ;
    ;;
  *)
    print_error "Invalid option. Use 'help' to see available commands." ;
    help ;
    ;;
esac