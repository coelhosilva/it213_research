"""DNN-2 model definition."""
import tensorflow as tf


def build_and_compile_model(norm):
    """Build and compile the Keras DNN model."""
    LEARNING_RATE = 0.001
    neurons = 200
    l2 = 0.0001
    
    hidden_layers = [
        
        tf.keras.layers.Dense(neurons, activation='relu', kernel_regularizer=tf.keras.regularizers.l2(l2)),
        tf.keras.layers.Dense(neurons, activation='relu', kernel_regularizer=tf.keras.regularizers.l2(l2)),
        tf.keras.layers.Dense(neurons, activation='relu', kernel_regularizer=tf.keras.regularizers.l2(l2)),
        tf.keras.layers.Dense(neurons, activation='relu', kernel_regularizer=tf.keras.regularizers.l2(l2)),
        tf.keras.layers.Dense(neurons, activation='relu', kernel_regularizer=tf.keras.regularizers.l2(l2)),
        tf.keras.layers.Dense(neurons, activation='relu', kernel_regularizer=tf.keras.regularizers.l2(l2)),        
    ]

    model = tf.keras.Sequential([
        norm,
        *hidden_layers,
        tf.keras.layers.Dense(1, activation='relu')
        ])

    model.compile(
        loss = 'huber',
        optimizer=tf.keras.optimizers.Adam(LEARNING_RATE)
    )

    return model
