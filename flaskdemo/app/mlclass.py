import tensorflow as tf
import os
# https://stackoverflow.com/questions/61796196/heroku-tensorflow-2-2-1-too-large-for-deployment/62356779#62356779
# Compiled slug size: 578.7M is too large (max is 500M).

# remove warning for cpu
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'
# https://keras.io/api/datasets/

# define functions because pycharm doesn't locate them
Dense = tf.keras.layers.Dense
Flatten = tf.keras.layers.Flatten
Conv2D = tf.keras.layers.Conv2D
BatchNormalization = tf.keras.layers.BatchNormalization
EarlyStopping = tf.keras.callbacks.EarlyStopping

# get data from online
mnist = tf.keras.datasets.mnist
(x_train, y_train), (x_test, y_test) = mnist.load_data()
