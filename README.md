# PredictionIO Setup Tools

This project provides a setup script to deploy All-in-One PredictionIO environment for development.

## Requirement

* Java 8

## Getting Started

### Deploy PredictionIO

Run the following command to deploy PredictionIO with Spark and Elasticsearch:

```
./bin/pio-setup deploy
```

This command creates predictionio, spark and elasticsearch directories.

### Start PredictionIO

To start PredictionIO, run as below:

```
./bin/pio-setup start
```

### Stop PredictionIO

To stop PredictionIO, run as below:

```
./bin/pio-setup stop
```

### Clean Deployed Softwares

Remove all deployed directories:

```
./bin/pio-setup clean
```

target, predictionio, spark and elasticsearch directories are removed.

## Details

### Storage Repositories

The following repositories are used:

* Meta Data: Elasticsearch
* Event Data: Elasticsearch
* Model Data: Local FS

### Directory Structure

This project contains the following directories:

* bin: Executable files
* predictionio: PredictionIO
* spark: Spark
* elasticsearch: Elasticsearch
* target: Temporary files
