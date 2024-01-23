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
	@/bin/sh -c './prereq.sh --check'

.PHONY: infra-up
infra-up: prereq-check ## Bring up and configure local or cloud infra
	@/bin/bash -c './infra.sh --up'

.PHONY: infra-down
infra-down: ## Bring down  local or cloud infra
	@/bin/bash -c './infra.sh --down'

.PHONY: infra-info
infra-info: ## Get infra environment info
	@/bin/bash -c './infra.sh --info'

.PHONY: teg-install
teg-install: ## Install TEG
	@/bin/bash -c './teg.sh --install'

.PHONY: teg-uninstall
teg-uninstall: ## Uninstall TEG
	@/bin/bash -c './teg.sh --uninstall'

.PHONY: scenario-deploy
scenario-deploy: ## Deploy the scenario
	@/bin/bash -c './scenario.sh --deploy'

.PHONY: scenario-undeploy
scenario-undeploy: ## Undeploy the scenario
	@/bin/bash -c './scenario.sh --undeploy'

.PHONY: scenario-info
scenario-info: ## Info about the scenario
	@/bin/bash -c './scenario.sh --info'


.PHONY: clean
clean: ## Clean up all resources
	@/bin/bash -c './infra.sh --clean'
	@/bin/bash -c 'rm -rf ./output/*'