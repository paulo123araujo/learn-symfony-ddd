#!/bin/bash

DOCKER_APP = learn-symfony.app
DOCKER_DB = learn-symfony.mysql
UID = $(shell id -u)

help: ## Show this help message
	@echo 'usage: make [target]'
	@echo
	@echo 'targets:'
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

run: ## Start the containers
	U_ID=${UID} docker-compose up -d

stop: ## Stop the containers
	U_ID=${UID} docker-compose down

restart: ## Restart the containers
	U_ID=${UID} docker-compose down && U_ID=${UID} docker-compose up -d

build: ## Rebuilds all the containers
	U_ID=${UID} docker-compose build

ssh-app: ## ssh's into the be container
	U_ID=${UID} docker exec -it ${DOCKER_APP} bash

ssh-db: ## ssh's into the db container as root user
	U_ID=${UID} docker exec -it ${DOCKER_DB} mysql -uroot -proot database

app-logs: ## Tails the Symfony dev log
	U_ID=${UID} docker exec -it ${DOCKER_APP} tail -f var/logs/dev.log

composer-install: ## Install composer dependencies
	U_ID=${UID} docker exec -it ${DOCKER_APP} composer install

migrations: ## Runs the migrations
	U_ID=${UID} docker exec -it ${DOCKER_APP} bin/console doctrine:migrations:migrate -n

app-tests: ## Run all tests
	U_ID=${UID} docker exec -it ${DOCKER_APP} ./vendor/bin/phpunit

app-phpcs: ## check code sniffer
	U_ID=${UID} docker exec -it ${DOCKER_APP} ./vendor/bin/phpcs --standard=PSR12 ./src ./tests

app-psalm:
	U_ID=${UID} docker exec -it ${DOCKER_APP} ./vendor/bin/psalm	

.PHONY: run stop restart build ssh-app ssh-db app-logs composer-install migrations app-tests