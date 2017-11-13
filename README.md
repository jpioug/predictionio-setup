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

## Example

This section describes Template development with pio-setup via [predictionio-template-iris](https://github.com/jpioug/predictionio-template-iris).

### PredictionIO Environment Setup

First of all, download and build PredictionIO environment including Spark and Elasticsearch.

```
git clone https://github.com/jpioug/predictionio-setup.git
cd predictionio-setup
./bin/pio-setup deploy
```

Run start command if the above deploy command is success. 

```
./bin/pio-setup start
```

You can check a status of PredictionIO by the following command:

```
./bin/pio-setup status
```

### Download Template

In this case, we use [predictionio-template-iris](https://github.com/jpioug/predictionio-template-iris).
get sub-command downloads it from jpioug/predictionio-template-iris in GitHub.

```
./bin/pio-setup template get iris
```

To use it on PredictionIO, you need to register it as PredictionIO application.
init sub-command invokes `pio app new` command.

```
./bin/pio-setup template init iris
```

### Import Data

To fit a learning model from training dataset, you need to insert data to PredictionIO event server.
import sub-command runs `python data/import_eventserver.py` with app's access key.

```
./bin/pio-setup template import iris
```

### Data Analysis and Model Development

Move to Template directory:

```
cd templates/predictionio-template-iris/
```

In this template, Jupyter notebook is available.
So, you can launch `jupyter` by the following command.
(If not using pyenv, modify environment variables)

```
PYSPARK_PYTHON=$PYENV_ROOT/shims/python PYSPARK_DRIVER_PYTHON=$PYENV_ROOT/shims/jupyter PYSPARK_DRIVER_PYTHON_OPTS="notebook" ../../predictionio/bin/pio-shell --with-pyspark
```

This tempalte contains eda.ipynb to run sample data analysis and create a learning model.
After finishing your work, download it as python code and copy&paste it to train.py.

Move back to predictionio-setup directory:

```
cd ../..
```

### Build Template

This template contains some Scala code.
build sub-command runs `pio build` on the template directory.

```
./bin/pio-setup template build iris
```

### Train Learning Model

To fit a learning model on the template, run train sub-command.
This command invokes `pio train`.

```
./bin/pio-setup template train iris
```

### Deploy Predict API

deploy sub-command launches Predict Rest API.

```
./bin/pio-setup template deploy iris
```

You can check it by the following request:

```
curl -s -H "Content-Type: application/json" -d '{"attr0":5.1,"attr1":3.5,"attr2":1.4,"attr3":0.2}' http://localhost:8000/queries.json
```

### Undeploy Predict API

To stop Predict API, run undeploy sub-command:

```
./bin/pio-setup template undeploy iris
```

## Others

### Build Docker Image

```
docker build --rm -t jpioug/pio-setup
```

### Run Docker Instance

```
docker-compose up --abort-on-container-exit
```
