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

### Get Template from GitHub

pio-setup provides template commands.
To get template repository from GitHub, run `pio-setup template get [user] [repository]`.
For example, to clone recommender template from apache/incubator-predictionio-template-recommender, the command is:

```
./bin/pio-setup template get apache incubator-predictionio-template-recommender
```

You can also omit it.

```
./bin/pio-setup template get recommender
```

Cloned repositories are put into templates directory.

### Register Template to PredictionIO

To use Template on PredictionIO, you need to register it as PredictionIO App.
init sub-command deals with it.

```
./bin/pio-setup template init recommender
```

### Import Data

import sub-command invokes Python script to import training data.
(Note: for recommender template, you need to put sample_movielens_data.txt to data directory)

```
./bin/pio-setup template import recommender
```

### Build Template

build sub-command run `pio build` to compile Template.
(Note: for recommender template, you need to put `scalaVersion := "2.11.0"` to build.sbt, and also uncomment `sc.setCheckpointDir("checkpoint")` in ALSAlgorithm.scala if StackOverflowException occurs)

```
./bin/pio-setup template build recommender
```

### Train on Template

To run train process, use train sub-command.

```
./bin/pio-setup template train recommender
```

### Deploy Predict API

To launch predict API, run deploy sub-command:

```
./bin/pio-setup template deploy recommender
```

For recommender template, to check predict API response, send the following request:

```
curl -H "Content-Type: application/json" -d '{ "user": "1", "num": 4 }' http://localhost:8000/queries.json
```

### Undeploy Predict API

To stop predict API, run undeploy sub-command:

```
./bin/pio-setup template undeploy recommender
```


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
* templates: Template Repositories
