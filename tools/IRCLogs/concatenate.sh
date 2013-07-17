#!/bin/sh

# Concatenates a load of CSV files together and outputs to stdout

# Header
head -n 1 "$1"

# Output all but header from each file
until [ -z "$1" ]
do
    tail -n +2 "$1"
    shift
done
