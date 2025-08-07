.PHONY: *
.DEFAULT_GOAL = run
.EXPORT_ALL_VARIABLES:

SHELL = /bin/bash
TAG = $(shell git tag | tail -n 1)
HOST_USER_ID = $(shell id -u)

run:
ifdef build
	@$(MAKE) -s build
else ifdef rebuild
	@$(MAKE) -s rebuild
else ifdef up
	@$(MAKE) -s up
else ifdef logs
	@$(MAKE) -s logs
else ifdef stop
	@$(MAKE) -s stop
else ifdef down
	@$(MAKE) -s down
else ifdef exec
	@$(MAKE) -s exec
else
	@$(MAKE) -s help
endif

help:
	@printf "\033[33mUsage:\033[0m\n  make target[=\"...\"]\n\n\033[33mTargets:\033[0m\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-14s\033[0m %s\n", $$1, $$2}'

build: ## Build images
	DOCKER_BUILDKIT=1 docker compose build $(build)

rebuild: ## Rebuild images without cache
	DOCKER_BUILDKIT=1 docker compose build --pull --no-cache $(rebuild)

up: ## Up containers with recreate
	docker compose up -d --force-recreate $(up)

ps: ## Show current containers
	docker compose ps

logs: ## Show current containers
	docker compose logs -f $(logs)

stop: ## Stop containers
	docker compose stop $(stop)

down: ## Down containers
	docker compose down $(down)

clear: ## Clear all logs and user files
	@read -s -N 10 -p $$'Press any 10 keys to continue\n'

	for dir in \
		logs \
	; do \
		if [ -d $$dir ]; then \
			find $$dir -type f ! -name ".git*" -exec rm {} +; \
		fi \
	done

exec: ## Exec command in some container; e.g. make exec="application sh"
	docker compose exec -u $(HOST_USER_ID) $(exec)