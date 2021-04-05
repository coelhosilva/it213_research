"""Closest model to DNN-1 average."""
##############################################################################
# LIBS
##############################################################################
import pandas as pd
from pathlib import Path
from dnn_1.dnn_1_best_model_training_function import train_test


##############################################################################
# DATA MODELING
##############################################################################
HOME = Path(__file__)
TRAIN_PATH = (HOME / "../../../data/data_processed/train.parquet").resolve()
VALID_PATH = (HOME / "../../../data/data_processed/valid.parquet").resolve()
TEST_PATH = (HOME / "../../../data/data_processed/test.parquet").resolve()

# Input
train = pd.read_parquet(TRAIN_PATH)
valid = pd.read_parquet(VALID_PATH)
test = pd.read_parquet(TEST_PATH)

# Prep
X = [
  "population_origin",
  "population_destination",
  "distance_km",
  "gdp_per_capita_origin",
  "gdp_per_capita_destination"
]

Y = "total_pax"

used_vars = X + [Y]

train = train[used_vars]
valid = valid[used_vars]
test = test[used_vars]

X_train = train[X]
X_valid = valid[X]
X_test = test[X]

y_train = train[Y].to_numpy()
y_valid = valid[Y].to_numpy()
y_test = test[Y].to_numpy()

##############################################################################
# MODEL TRAINING
##############################################################################
seed_avg_performance = 239

hist, rmse, mae, mape, y_test_pred = train_test(seed_avg_performance, X_train, y_train, X_valid, y_valid, X_test, y_test)


##############################################################################
# OUTPUTS
##############################################################################
prediction_df = pd.DataFrame({'actual': y_test, 'prediction': y_test_pred, 'Model': 'DNN-1'})
error_df = pd.DataFrame({'error': y_test_pred - y_test, 'Model': 'DNN-1'})

write_csv = False
if write_csv:
    prediction_df.to_csv('test_predictions_dnn_1.csv', index=False)
    error_df.to_csv('error_df_dnn_1.csv', index=False)
    hist.to_csv('dnn_1_training_history.csv', index=False)
