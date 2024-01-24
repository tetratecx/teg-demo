# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

.PHONY: up down info
up: infra-up teg-install scenario-deploy info ## Bring up full demo scenario
down: clean ## Bring down full demo scenario
info: infra-info scenario-info ## Get information about infra environment and scenario

.PHONY: prereq-check
prereq-check: ## Check if prerequisites are installed
	# @/bin/sh -c './make.sh --prereq-check'

.PHONY: infra-up
infra-up: prereq-check ## Bring up and configure the infrastructure
	@/bin/bash -c './make.sh --infra-up'

.PHONY: infra-down
infra-down: ## Bring down the infrastructure
	@/bin/bash -c './make.sh --infra-down'

.PHONY: infra-info
infra-info: ## Get infrastructure information
	@/bin/bash -c './make.sh --infra-info'

.PHONY: teg-install
teg-install: ## Install Tetrate Envoy Gateway (TEG)
	@/bin/bash -c './make.sh --teg-install'

.PHONY: teg-uninstall
teg-uninstall: ## Uninstall Tetrate Envoy Gateway (TEG)
	@/bin/bash -c './make.sh --teg-uninstall'

.PHONY: scenario-deploy
scenario-deploy: ## Deploy the scenario
	@/bin/bash -c './make.sh --scenario-deploy'

.PHONY: scenario-undeploy
scenario-undeploy: ## Undeploy the scenario
	@/bin/bash -c './make.sh --scenario-undeploy'

.PHONY: scenario-info
scenario-info: ## Get scenario information
	@/bin/bash -c './make.sh --scenario-info'


.PHONY: clean
clean: ## Clean up all resources
	@/bin/bash -c './make.sh --clean'
	@/bin/bash -c 'rm -rf ./output/*'