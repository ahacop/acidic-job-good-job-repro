# Variables
DOCKER_COMPOSE = docker-compose
COMPOSE_FILE = docker-compose.yml
SERVICE = web

# Targets

# Build the Docker images using Dockerfile.dev
build:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) build

# Start the services in the background
up:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) up -d

# Stop and remove containers, networks, images, and volumes
down:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) down

# Start the services and show logs
up-logs:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) up

# Run the Rails console inside the container
console:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) run $(SERVICE) ./bin/rails console

# Run the Rails server inside the container
server:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) run --service-ports $(SERVICE)

# Run database migrations
migrate:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) run $(SERVICE) ./bin/rails db:migrate

# Run tests inside the container
test:
	$(DOCKER_COMPOSE) run -e BACKTRACE=1 $(SERVICE) ./bin/rails test

# Install new gems after modifying the Gemfile
bundle-install:
	$(DOCKER_COMPOSE) run $(SERVICE) bundle install

# Rebuild the Docker image after modifying the Gemfile
rebuild:
	$(DOCKER_COMPOSE) build

# Install new gems and rebuild the Docker image
add-gem: bundle-install rebuild

# Start an interactive shell in the web service container
shell:
	$(DOCKER_COMPOSE) run $(SERVICE) /bin/bash

# Tail logs from the services
logs:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) logs -f

# Clean up containers, images, volumes
clean:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) down --volumes --remove-orphans

dbcreate:
	$(DOCKER_COMPOSE) run $(SERVICE) ./bin/rails db:create

setup: dbcreate migrate

.PHONY: build up down up-logs console server migrate test bundle-install rebuild add-gem rails shell logs clean setup
