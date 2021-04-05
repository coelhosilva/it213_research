"""Filtering and exporting od matrix with econ data."""
##############################################################################
# LIBS
##############################################################################
try:
    from .od_city_tele_combined_complete import df_od as dataset
    from pathlib import Path
except:
    from od_city_tele_combined_complete import df_od as dataset
    from pathlib import Path

##############################################################################
# IMPORTING THE DATA
##############################################################################
dataset_filtered = dataset.\
    loc[dataset["distance_km"] > 200].\
        loc[dataset["total_pax"] > 1000].\
            reset_index(drop=True)

HOME = Path(__file__).parent.parent
DATA_PATH_PARQUET = (HOME / "./data_processed/od_matrix_complete.parquet").resolve()

WRITE_OUTPUTS = True
if WRITE_OUTPUTS:
    dataset.to_parquet(DATA_PATH_PARQUET, index=False)
