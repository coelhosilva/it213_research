"""Geographical database."""
##############################################################################
# LIBS
##############################################################################
import pandas as pd
from pathlib import Path

##############################################################################
# IMPORTING THE DATA
##############################################################################
"""
Data title: City geographical database.
Data source: OpenStreetMap.
Data year: 2021.
Data description:
    City geographical database, comprising of the follow information:
        - city;
        - reference address;
        - latitude;
        - longitude.
"""


HOME = Path(__file__).parent.parent
DATA_PATH = (HOME / "./data_raw/cities_db_complete.pkl").resolve()

df = pd.read_pickle(DATA_PATH)
