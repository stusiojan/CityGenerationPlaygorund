from pathlib import Path

from dotenv import load_dotenv
from loguru import logger

"""
Configuration file for project.
"""

# Load environment variables from .env file if it exists
load_dotenv()

# Paths
PROJ_ROOT = Path(__file__).resolve().parents[1]

TERRAIN_DIR = PROJ_ROOT / "Terrain"
DATA_DIR = TERRAIN_DIR / "data"
