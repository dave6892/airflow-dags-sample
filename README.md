# Airflow DAGs Sample Project
[![Python 3.12+](https://img.shields.io/badge/python-3.9+-blue.svg)](https://www.python.org/downloads/)
[![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

A sample project demonstrating configuration-driven Apache Airflow DAG development using [dag-factory](https://github.com/ajbosco/dag-factory).

## Overview

This project showcases how to build scalable Apache Airflow workflows using YAML configuration files instead of traditional Python DAG definitions. By leveraging dag-factory, DAGs can be defined declaratively, making them easier to maintain, version, and manage at scale.

## Features

- **Configuration-Driven DAGs**: Define workflows in YAML for better maintainability
- **Docker Development Environment**: Complete local Airflow setup with Docker Compose
- **Code Quality Automation**: Pre-commit hooks with linting and formatting
- **Multiple DAG Examples**: Sample workflows demonstrating different scheduling patterns
- **Scalable Architecture**: Easy to add new DAGs without writing Python code

## Project Structure

```
.
├── .dev/
│   ├── Dockerfile              # Custom Airflow image
│   └── docker-compose.yaml     # Local development environment
├── dags/
│   ├── example_dag.py          # Python wrapper for dag-factory
│   ├── example_dag_1.yml       # DAG configuration (runs at 1 AM)
│   ├── example_dag_2.yml       # DAG configuration (runs at 2 AM)
│   └── example_dag_3.yml       # DAG configuration (runs at 3 AM)
├── .pre-commit-config.yaml     # Code quality automation
├── Makefile                    # Development workflow automation
├── pyproject.toml              # Python dependencies
└── README.md
```

## Quick Start

### Prerequisites

- Python 3.12+
- Docker and Docker Compose
- Git

### Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/dave6892/airflow-dags-sample.git
   cd airflow-dags-sample
   ```

2. **Install dependencies**:
   ```bash
   # Using uv (recommended)
   uv sync

   # Or using pip
   pip install -e .
   ```

3. **Set up pre-commit hooks**:
   ```bash
   pre-commit install
   ```

4. **Start the Airflow environment**:

   **Option A: Using Makefile (Recommended)**:
   ```bash
   make airflow-up
   ```

   **Option B: Using Docker Compose directly**:
   ```bash
   cd .dev
   docker-compose up -d
   ```

5. **Access Airflow UI**:
   - URL: http://localhost:8080
   - Username: `airflow`
   - Password: `airflow`

## Usage

### Creating New DAGs

To create a new DAG, simply add a new YAML file in the `dags/` directory:

```yaml
# dags/my_new_dag.yml
default:
  default_args:
    catchup: false
    start_date: 2024-11-11

my_workflow:
  default_args:
    owner: "your_name"
  description: "Description of your workflow"
  schedule_interval: "0 4 * * *"  # Run at 4 AM daily
  render_template_as_native_obj: True
  tasks:
    extract_data:
      operator: airflow.operators.bash_operator.BashOperator
      bash_command: "echo 'Extracting data...'"
    process_data:
      operator: airflow.operators.bash_operator.BashOperator
      bash_command: "echo 'Processing data...'"
      dependencies: [extract_data]
    load_data:
      operator: airflow.operators.bash_operator.BashOperator
      bash_command: "echo 'Loading data...'"
      dependencies: [process_data]
```

The DAG will be automatically discovered and loaded by Airflow.

### Example DAGs

The project includes three sample DAGs:

- **example_dag_1**: Runs daily at 1:00 AM
- **example_dag_2**: Runs daily at 2:00 AM
- **example_dag_3**: Runs daily at 3:00 AM

Each DAG demonstrates a simple workflow with three bash tasks showing task dependencies.

## Makefile Commands

This project includes a comprehensive Makefile to streamline development workflows. Here are the most commonly used commands:

### Quick Setup
```bash
make setup          # Complete project setup (uv + pre-commit)
make setup-pip      # Complete project setup using pip
make dev-start      # Setup and start complete development environment
```

### Airflow Operations
```bash
make airflow-up     # Start Airflow development environment
make airflow-down   # Stop Airflow development environment
make airflow-restart # Restart Airflow services
make airflow-logs   # View all Airflow logs
make airflow-status # Check status of Airflow services
make airflow-shell  # Open shell in Airflow container
```

### Code Quality
```bash
make lint           # Run linting checks
make format         # Format code
make lint-fix       # Auto-fix linting issues
make check          # Run all quality checks (lint + format + test)
make fix            # Fix all code issues and format
```

### Testing
```bash
make test           # Run tests
make test-cov       # Run tests with coverage
make test-verbose   # Run tests with verbose output
```

### Cleanup
```bash
make clean          # Clean temporary files and caches
make clean-all      # Clean everything including Docker resources
make dev-reset      # Reset and restart development environment
```

### Help
```bash
make help           # Show all available commands
make                # Default target (shows help)
```

## Development

### Code Quality

This project uses several tools to maintain code quality:

- **Ruff**: Python linting and formatting
- **Pre-commit hooks**: Automatic checks before commits
- **YAML validation**: Ensures configuration files are valid

### Testing

To run tests:

```bash
pytest
```

### Docker Environment

The Docker Compose setup includes:

- **Airflow Webserver**: Web UI at http://localhost:8080
- **Airflow Scheduler**: DAG scheduling and execution
- **Airflow Worker**: Task execution (Celery)
- **PostgreSQL**: Metadata database
- **Redis**: Message broker for Celery

## Configuration

### Environment Variables

Customize the environment by creating a `.env` file in the `.dev/` directory:

```bash
# .dev/.env
AIRFLOW_UID=50000
_AIRFLOW_WWW_USER_USERNAME=admin
_AIRFLOW_WWW_USER_PASSWORD=admin
ENVIRONMENT=development
```

### DAG Factory Configuration

Refer to the [dag-factory documentation](https://astronomer.github.io/dag-factory/latest/getting-started/quick-start-airflow-standalone/) for advanced configuration options.

## Known Limitations

⚠️ **Airflow UI Code View**: The Airflow UI's "Code" view cannot display YAML configuration files. Users will only see the Python wrapper code (`example_dag.py`) rather than the actual YAML configuration that defines the DAG structure.

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes
4. Run pre-commit checks: `pre-commit run --all-files`
5. Commit your changes: `git commit -m 'Add feature'`
6. Push to the branch: `git push origin feature-name`
7. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Resources

- [Apache Airflow Documentation](https://airflow.apache.org/docs/)
- [dag-factory Documentation](https://astronomer.github.io/dag-factory/latest/getting-started/quick-start-airflow-standalone/)
- [Docker Compose for Airflow](https://airflow.apache.org/docs/apache-airflow/stable/howto/docker-compose/index.html)
