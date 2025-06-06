import os
from pathlib import Path
import glob

# The following import is here so Airflow parses this file
# from airflow import DAG
import dagfactory

DEFAULT_CONFIG_ROOT_DIR = "/opt/airflow/dags/"
CONFIG_ROOT_DIR = Path(os.getenv("CONFIG_ROOT_DIR", DEFAULT_CONFIG_ROOT_DIR))

# Create a list to store all DAG factories
dag_factories = []

# Get all YAML files in the directory
yaml_files = glob.glob(str(CONFIG_ROOT_DIR / "*.yml"))

# Create DAG factories for each YAML file
for config_file in yaml_files:
    dag_factory = dagfactory.DagFactory(config_file)
    dag_factories.append(dag_factory)

# Clean DAGs once at the start
if dag_factories:
    dag_factories[0].clean_dags(globals())

# Generate all DAGs
for factory in dag_factories:
    factory.generate_dags(globals())
