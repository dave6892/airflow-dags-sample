from pathlib import Path
import os
import glob
from dagfactory import load_yaml_dags


DEFAULT_CONFIG_ROOT_DIR = "/opt/airflow/dags/"
CONFIG_ROOT_DIR = Path(os.getenv("CONFIG_ROOT_DIR", DEFAULT_CONFIG_ROOT_DIR))


yaml_files = glob.glob(str(CONFIG_ROOT_DIR / "*.yml"))
config_dir = CONFIG_ROOT_DIR / "configs"

load_yaml_dags(globals_dict=globals(), dags_folder=config_dir)
