"""DNN-1 model definition."""
import tensorflow as tf


def build_and_compile_model(norm):
    """Build and compile the Keras DNN model."""
    LEARNING_RATE = 0.01
    
    hidden_layers = [
        tf.keras.layers.Dense(640, activation='relu'),        
        tf.keras.layers.Dense(736, activation='relu'),
        tf.keras.layers.Dense(704, activation='relu'),
    ]

    model = tf.keras.Sequential([
        norm,
        *hidden_layers,
        tf.keras.layers.Dense(1, activation='relu')
        ])

    model.compile(
        loss='huber',
        optimizer=tf.keras.optimizers.Adam(LEARNING_RATE)
    )

    return model
