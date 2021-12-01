#!/bin/bash
# $1 = ~/weka-3-8-5 
# $2 = Absolute path to directory to convert to .arff and train on
cd "$1";
# Set your weka source code on your path for the current session.
export CLASSPATH=$CLASSPATH:`pwd`/weka.jar:`pwd`/libsvm.jar;
# $2 should be a directory containing two folders of different classifications, that in turn contain the datafiles to train on.
# We convert it to a word vector in .arff format, which weka uses as input for its classifiers.
java weka.core.converters.TextDirectoryLoader -dir "$2" > ~/weka_output/reviews.arff
java -Xmx1024m weka.filters.unsupervised.attribute.StringToWordVector -i ~/weka_output/reviews.arff -o ~/weka_output/reviews_training.arff -M 2
# We can then attempt to classify the data using regression.
# This shell script will output classification results.
java -Xmx1024m  weka.classifiers.meta.ClassificationViaRegression -W weka.classifiers.trees.M5P -num-decimal-places 4 -t ~/weka_output/reviews_training.arff -d ~/weka_output/reviews_training.model -c 1
