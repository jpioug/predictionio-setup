FROM java:8

MAINTAINER CodeLibs Project

ENV PIO_DEFAULT_CONF /opt/predictionio/conf/pio-default.sh

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.3.27-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

ADD bin /opt/bin
ADD docker/run.sh /opt/bin/run.sh
ADD spark /opt/spark
ADD predictionio /opt/predictionio
RUN mv /opt/predictionio/conf/pio-env.sh $PIO_DEFAULT_CONF
RUN sed -i "s/^PIO_STORAGE_SOURCES_ELASTICSEARCH_HOSTS=.*/PIO_STORAGE_SOURCES_ELASTICSEARCH_HOSTS=elasticsearch1/" $PIO_DEFAULT_CONF
RUN sed -i "s/^PIO_STORAGE_SOURCES_ELASTICSEARCH_HOME=.*/PIO_STORAGE_SOURCES_ELASTICSEARCH_HOME=/" $PIO_DEFAULT_CONF
RUN sed -i "s/^SPARK_HOME=.*/SPARK_HOME=\/opt\/spark/" $PIO_DEFAULT_CONF
ADD docker/pio-env.sh /opt/predictionio/conf/pio-env.sh

RUN /opt/conda/bin/pip install predictionio

ENV PATH /opt/bin:/opt/conda/bin:/opt/predictionio/bin:/opt/spark/bin:$PATH

WORKDIR /work

EXPOSE 7070
EXPOSE 8000

CMD ["sh", "/opt/bin/run.sh"]

