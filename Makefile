.PHONY: help install install-dev test lint format clean docker-build docker-up docker-down docker-restart docker-logs docker-clean airflow-up airflow-down airflow-restart airflow-logs setup pre-commit-install pre-commit-run

# Default target
help: ## Show this help message
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Python environment setup
install: ## Install project dependencies
	uv sync

install-dev: ## Install project with development dependencies
	uv sync --group dev

install-pip: ## Install using pip (alternative to uv)
	pip install -e .
	pip install -e ".[dev]"

# Code quality
lint: ## Run linting checks
	uv run ruff check .

format: ## Format code
	uv run ruff format .

format-check: ## Check code formatting without making changes
	uv run ruff format --check .

lint-fix: ## Run linting with auto-fix
	uv run ruff check --fix .

# Testing
test: ## Run tests
	uv run pytest

test-cov: ## Run tests with coverage
	uv run pytest --cov=. --cov-report=html --cov-report=term

test-verbose: ## Run tests with verbose output
	uv run pytest -v

# Pre-commit
pre-commit-install: ## Install pre-commit hooks
	pre-commit install

pre-commit-run: ## Run pre-commit hooks on all files
	pre-commit run --all-files

# Docker operations
docker-build: ## Build custom Airflow Docker image
	cd .dev && docker-compose build

docker-up: airflow-up ## Start Airflow services (alias for airflow-up)

docker-down: airflow-down ## Stop Airflow services (alias for airflow-down)

docker-restart: airflow-restart ## Restart Airflow services (alias for airflow-restart)

docker-logs: airflow-logs ## View Airflow logs (alias for airflow-logs)

docker-clean: ## Clean up Docker containers and volumes
	cd .dev && docker-compose down -v --remove-orphans
	docker system prune -f

# Airflow specific operations
airflow-up: ## Start Airflow development environment
	@echo "Starting Airflow development environment..."
	cd .dev && docker-compose up -d
	@echo "Airflow is starting up. Please wait a moment..."
	@echo "Access Airflow UI at: http://localhost:8080"
	@echo "Username: airflow"
	@echo "Password: airflow"

airflow-down: ## Stop Airflow development environment
	@echo "Stopping Airflow development environment..."
	cd .dev && docker-compose down

airflow-restart: ## Restart Airflow development environment
	@echo "Restarting Airflow development environment..."
	cd .dev && docker-compose restart

airflow-logs: ## View Airflow logs
	cd .dev && docker-compose logs -f

airflow-logs-webserver: ## View Airflow webserver logs
	cd .dev && docker-compose logs -f airflow-webserver

airflow-logs-scheduler: ## View Airflow scheduler logs
	cd .dev && docker-compose logs -f airflow-scheduler

airflow-logs-worker: ## View Airflow worker logs
	cd .dev && docker-compose logs -f airflow-worker

airflow-status: ## Check status of Airflow services
	cd .dev && docker-compose ps

airflow-shell: ## Open shell in Airflow webserver container
	cd .dev && docker-compose exec airflow-webserver bash

# Project setup
setup: install-dev pre-commit-install ## Complete project setup
	@echo "Project setup complete!"
	@echo "To start Airflow: make airflow-up"

setup-pip: install-pip pre-commit-install ## Complete project setup using pip
	@echo "Project setup complete!"
	@echo "To start Airflow: make airflow-up"

# Cleanup
clean: ## Clean up temporary files and caches
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete
	find . -type d -name "*.egg-info" -exec rm -rf {} +
	find . -type f -name ".coverage" -delete
	find . -type d -name "htmlcov" -exec rm -rf {} +
	find . -type d -name ".pytest_cache" -exec rm -rf {} +
	find . -type d -name ".ruff_cache" -exec rm -rf {} +

clean-all: clean docker-clean ## Clean everything including Docker resources

# Development workflow
dev-start: setup airflow-up ## Start complete development environment
	@echo "Development environment is ready!"
	@echo "Airflow UI: http://localhost:8080 (airflow/airflow)"

dev-stop: airflow-down ## Stop development environment

dev-reset: airflow-down docker-clean setup airflow-up ## Reset and restart development environment
	@echo "Development environment has been reset and restarted!"

# Quick commands
check: lint format-check test ## Run all quality checks

fix: lint-fix format ## Fix code issues and format

# Default target when no target is specified
default: help
