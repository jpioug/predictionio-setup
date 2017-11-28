FROM java:8

MAINTAINER Japan PredictionIO User Group

ENV PIO_DEFAULT_CONF /opt/predictionio/conf/pio-default.sh
ENV PIO_USER predictionio

RUN apt-get update && apt-get install -y sudo libgfortran3 liblapack3 && \
    apt-get clean
RUN groupadd -g 1000 $PIO_USER && \
    useradd -g $PIO_USER -G sudo -m -s /bin/bash $PIO_USER -d /work && \
    echo "$PIO_USER:$PIO_USER" | chpasswd

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.3.30-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

ADD bin /opt/bin
ADD docker/run.sh /opt/bin/run.sh
ADD spark /opt/spark
ADD predictionio /opt/predictionio
RUN mv /opt/predictionio/conf/pio-env.sh $PIO_DEFAULT_CONF
RUN sed -i "s/^PIO_FS_BASEDIR=.*/PIO_FS_BASEDIR=\/work\/.pio_store/" $PIO_DEFAULT_CONF
RUN sed -i "s/^PIO_STORAGE_SOURCES_ELASTICSEARCH_HOSTS=.*/PIO_STORAGE_SOURCES_ELASTICSEARCH_HOSTS=elasticsearch1/" $PIO_DEFAULT_CONF
RUN sed -i "s/^PIO_STORAGE_SOURCES_ELASTICSEARCH_HOME=.*/PIO_STORAGE_SOURCES_ELASTICSEARCH_HOME=/" $PIO_DEFAULT_CONF
RUN sed -i "s/^SPARK_HOME=.*/SPARK_HOME=\/opt\/spark/" $PIO_DEFAULT_CONF
ADD docker/pio-env.sh /opt/predictionio/conf/pio-env.sh
RUN chown -R $PIO_USER /opt/predictionio /opt/spark

RUN /opt/conda/bin/pip install numpy==1.13.3
RUN /opt/conda/bin/pip install pandas==0.21.0
RUN /opt/conda/bin/pip install predictionio==0.9.9

ENV PATH /opt/bin:/opt/conda/bin:/opt/predictionio/bin:/opt/spark/bin:$PATH

WORKDIR /work
EXPOSE 7070
EXPOSE 8000
EXPOSE 8888

CMD ["sh", "/opt/bin/run.sh"]

