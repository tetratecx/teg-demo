#!/usr/bin/env bash
BASE_DIR="$( cd -- "$(dirname "${0}")" >/dev/null 2>&1 ; pwd -P )" ;

# shellcheck source=/dev/null
source "${BASE_DIR}/helpers/azure.sh" ;
# shellcheck source=/dev/null
source "${BASE_DIR}/helpers/certs.sh" ;
# shellcheck source=/dev/null
source "${BASE_DIR}/helpers/print.sh" ;

ACTION=${1} ;

# This function provides help information for the script.
#
function help() {
  echo "Usage: $0 <command> [options]" ;
  echo "Commands:" ;
  echo "  --up: bring up the instrastructure" ;
  echo "  --down: bring down the instrastructure" ;
  echo "  --info: print info about the instrastructure" ;
  echo "  --clean: remove the instrastructure" ;
}

# This function brings up the instrastructure.
#
function up() {
  print_info "Going to bring up the infrastructure" ;

  start_aks_cluster "$(jq -c .azure_aks infra.json)" ;
}

# This function brings down the instrastructure.
#
function down() {
  print_info "Going to bring down the infrastructure" ;

  stop_aks_cluster "$(jq -c .azure_aks infra.json)" ;
}

# This function prints info about the instrastructure.
#
function info() {
  print_info "Going to print info about the infrastructure" ;

  info_aks_cluster "$(jq -c .azure_aks infra.json)" ;
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
  --up)
    print_stage "Going to bring up the infrastructure" ;
    start_time=$(date +%s); up; elapsed_time=$(( $(date +%s) - start_time )) ;
    print_stage "Brought up infrastructure in ${elapsed_time} seconds" ;
    ;;
  --down)
    print_stage "Going to bring down the infrastructure" ;
    start_time=$(date +%s); down; elapsed_time=$(( $(date +%s) - start_time )) ;
    print_stage "Brought down infrastructure in ${elapsed_time} seconds" ;
    ;;
  --info)
    print_stage "Going to print info about the infrastructure" ;
    info ;
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