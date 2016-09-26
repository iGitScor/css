.SILENT:
.PHONY: help

## Colors
COLOR_RESET   = \033[0m
COLOR_INFO    = \033[32m
COLOR_COMMENT = \033[33m

## Help
help:
	printf "${COLOR_COMMENT}Usage:${COLOR_RESET}\n"
	printf " make [target]\n\n"
	printf "${COLOR_COMMENT}Available targets:${COLOR_RESET}\n"
	awk '/^[a-zA-Z\-\_0-9\.@]+:/ { \
	helpMessage = match(lastLine, /^## (.*)/); \
	if (helpMessage) { \
	helpCommand = substr($$1, 0, index($$1, ":")); \
	helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
	printf " ${COLOR_INFO}%-16s${COLOR_RESET} %s\n", helpCommand, helpMessage; \
	} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

###########
# Install #
###########

## Install application
install: install-deps

## Install dependencies
install-deps: install-npm install-submodules

## Install npm
install-npm:
	npm install

## Install git
install-submodules:
	git submodule foreach git pull origin master
	git submodule foreach npm install

##########
# Update #
##########

## Update deps
update-deps: install-submodules

##########
# Doc    #
##########

## Generate documentation
documentation:
	make update-deps
	gulp --gulpfile docs/tool/gulpfile.js generate

##########
# Deploy #
##########

## Deploy
deploy: documentation deploy-documentation

deploy-application:
	node ./config/gh-deploy.js
