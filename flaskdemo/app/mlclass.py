import tensorflow as tf
import os

# remove warning for cpu
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

# define functions because pycharm doesn't locate them
Dense = tf.keras.layers.Dense
Flatten = tf.keras.layers.Flatten
Conv2D = tf.keras.layers.Conv2D
BatchNormalization = tf.keras.layers.BatchNormalization
EarlyStopping = tf.keras.callbacks.EarlyStopping

# get data from online
mnist = tf.keras.datasets.mnist
(x_train, y_train), (x_test, y_test) = mnist.load_data()
