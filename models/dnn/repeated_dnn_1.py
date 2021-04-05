"""Repeated model training for assessing performance."""
##############################################################################
# LIBS
##############################################################################
import pandas as pd
from pathlib import Path
import time
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
previous_round = 0
rounds = 240

rmse_list = []
mae_list = []
mape_list = []
time_list = []


for training_round in range(previous_round, previous_round+rounds):
    print("Training round {}...".format(training_round))
    start = time.time()
    _, rmse, mae, mape, _ = train_test(training_round, X_train, y_train, X_valid, y_valid, X_test, y_test)
    
    rmse_list.append(rmse)
    mae_list.append(mae)
    mape_list.append(mape)
    time_list.append(time.time() - start)
    
    print("RMSE: {}".format(rmse))
    print("Last model trained in {} seconds.".format(time_list[-1]))
   

model_performance = pd.DataFrame({'rmse': rmse_list, 'mae': mae_list, 'mape': mape_list, 'training_time': time_list})
model_performance['Model'] = 'DNN-1'
model_performance.to_csv('dnn_1_performance_240_rounds.csv',index=False)
