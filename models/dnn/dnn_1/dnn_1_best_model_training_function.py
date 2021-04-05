"""
DNN-1.

Keras' DNN-1.
"""
##############################################################################
# LIBS
##############################################################################
import numpy as np
import pandas as pd
import tensorflow as tf
from sklearn.metrics import mean_squared_error, mean_absolute_error


def mean_absolute_percentage_error(y, y_pred):
    """Compute the Mean Absolute Percentage Error (MAPE)."""
    ape = np.abs((y_pred - y)/y)
    
    return np.mean(ape)


def train_test(seed, X_train, y_train, X_valid, y_valid, X_test, y_test):
    """Construct and train the keras model."""
    tf.random.set_seed(seed)
    np.random.seed(seed)
    
    from dnn_1.dnn_1_best_model import build_and_compile_model

    # Normalization
    normalizer = tf.keras.layers.experimental.preprocessing.Normalization()
    normalizer.adapt(np.array(X_train))
    
    model = build_and_compile_model(normalizer)
    
    # print(model.summary())
    
    ##########################################################################
    # MODEL TRAINING
    ##########################################################################
    # Training
    history = model.fit(
        X_train, y_train,
        validation_data=(X_valid, y_valid),
        verbose=False, epochs=150)
    
    # Assessing training loss
    hist = pd.DataFrame(history.history)
    hist['epoch'] = history.epoch
    
    # Predicting
    y_test_pred = np.array(model.predict(X_test)).flatten()
    
    # Performance
    rmse = np.sqrt(mean_squared_error(y_test, y_test_pred))
    mae = mean_absolute_error(y_test, y_test_pred)
    mape = mean_absolute_percentage_error(y_test, y_test_pred)
    
    
    return hist, rmse, mae, mape, y_test_pred

