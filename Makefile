# Project
SHELL := /bin/bash
PROJECT := project
NAME := project
VERSION := 0.1.0
BUILD_DATE := $(shell date +%Y%m%d)
GIT_VERSION := $(shell git describe --long --all 2>/dev/null)
SHA := $(shell git rev-parse --short=8 HEAD 2>/dev/null)

# Toolchain
PYTHON := python3
PYTHON_VERSION := 3.8.10
PYTHON_MANAGER := pipenv
PYTHON_BUILDER := pyinstaller
PYTHON_LINTER := pylint
PYTHON_TEST := pytest
PYTHON_DEPS := $(shell $(PYTHON_MANAGER) run $(PYTHON) scripts/fetch_deps.py)

# Main
MAIN_ENTRY_FILE := src/main.py

# Docker
DOCKER ?= docker
DOCKER_CONTEXT := .
DOCKERFILE := ci/docker/Dockerfile
REGISTRY := docker.io
IMAGE_NAME := library/$(PROJECT)
FULL_IMAGE_NAME := $(REGISTRY)/$(IMAGE_NAME):$(VERSION)-$(BUILD_DATE)

##@ General

.PHONY: help
help: ## Print help info
	@ awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: venv
venv: ## Enter local isolated virtual venv
	@ $(PYTHON_MANAGER) shell 

##@ Development

.PHONY: install
install: ## Install dependencies
	$(PYTHON_MANAGER) install
	$(PYTHON_MANAGER) install -d

.PHONY: lint
lint: ## Check
	$(PYTHON_MANAGER) run $(PYTHON_LINTER) src/**.py

.PHONY: format
format: ## Format against code
	@ echo "Unsupported"

.PHONY: clean
clean: ## Cleatn target artifact
	@ -rm -rf build
	@ -rm -rf dist
	@ -rm -rf .pytest_cache
	@ -rm -rf __pycache__
	@ -rm -f *.spec

.PHONY: unittest
unittest: ## Run all unit tests
	@ echo "Implement your code here"

.PHONY: test
test: ## Run all integrity tests 
	@ echo "Implement your code here"

##@ Build

.PHONY: build
build: ## Run the target artifact
	$(PYTHON_MANAGER) run $(PYTHON_BUILDER) \
	  --name $(PROJECT) \
	  --onefile $(MAIN_ENTRY_FILE) \
	  --strip \
	  --clean \
	  --hidden-import $(PYTHON_DEPS)

.PHONY: image
image: ## Build the OCI image
	$(DOCKER) build \
	  --tag $(NIGHTLY_IMAGE_NAME) \
	  --file $(DOCKERFILE) \
	  --build-arg MIRRORS_SOURCE=mirrors.tuna.tsinghua.edu.cn \
	  --build-arg PYPI_SOURCE=pypi.tuna.tsinghua.edu.cn \
	  $(DOCKER_CONTEXT)
	$(DOCKER) tag $(NIGHTLY_IMAGE_NAME) $(FULL_IMAGE_NAME)