FROM ubuntu:18.04

RUN mkdir /root/app
WORKDIR /root/app

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV PIO_SOURCE_TAR_URL http://www-eu.apache.org/dist/predictionio/0.12.1/apache-predictionio-0.12.1.tar.gz
ENV PIO_HOME ${PWD}/apache-predictionio-0.12.1

# Install system dependencies
RUN apt-get update \
    && apt-get install -y --auto-remove --no-install-recommends curl openjdk-8-jdk libgfortran3 python-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Build & install Prediction.IO
RUN curl -O ${PIO_SOURCE_TAR_URL} \
    && mkdir ${PIO_HOME} \
    && (cd ${PIO_HOME} \
        && tar xvzf ../$(basename ${PIO_SOURCE_TAR_URL}) \
        && ./make-distribution.sh) 

RUN echo "export PATH=${PIO_HOME}/bin:${PATH}" > ~/.bashrc \
    && source ~/.bashrc

RUN mkdir ${PIO_HOME}/vendors 

ENV SPARK_SOURCE_TAR_URL http://d3kbcqa49mib13.cloudfront.net/spark-2.1.1-bin-hadoop2.6.tgz

# Install Spark
RUN curl -O ${SPARK_SOURCE_TAR_URL} \
    && tar zxvfC $(basename ${SPARK_SOURCE_TAR_URL}) ${PIO_HOME}/vendors/

ENV ELASTICSEARCH_SOURCE_TAR_URL https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.5.2.tar.gz

# Install Elasticsearch
RUN curl -O ${ELASTICSEARCH_SOURCE_TAR_URL} \
    && tar zxvfC $(basename ${ELASTICSEARCH_SOURCE_TAR_URL}) ${PIO_HOME}/vendors/

ENV HBASE_SOURCE_TAR_URL http://archive.apache.org/dist/hbase/1.2.6/hbase-1.2.6-bin.tar.gz

# Install HBase
RUN curl -O ${HBASE_SOURCE_TAR_URL} \
    && tar zxvfC $(basename ${HBASE_SOURCE_TAR_URL}) ${PIO_HOME}/vendors/

# Configure Prediction.IO
COPY ./dockerfile-config/pio-env.sh ${PIO_HOME}/conf/pio-env.sh

# Configure HBase
COPY ./dockerfile-config/hbase-site.xml $(PIO_HOME)/vendor/hbase-1.2.6/conf/hbase-site.xml
RUN sed -i "s|VAR_PIO_HOME|${PIO_HOME}|" $(PIO_HOME)/vendor/hbase-1.2.6/conf/hbase-site.xml

# ENV PIO_VERSION 0.12.1
# ENV SPARK_VERSION 1.5.1
# ENV ELASTICSEARCH_VERSION 1.4.4
# ENV HBASE_VERSION 1.0.0

# ENV PIO_HOME /PredictionIO-${PIO_VERSION}-incubating
# ENV PATH=${PIO_HOME}/bin:$PATH

# RUN curl -O http://mirror.nexcess.net/apache/incubator/predictionio/${PIO_VERSION}-incubating/apache-predictionio-${PIO_VERSION}-incubating.tar.gz \
#     && tar -xvzf apache-predictionio-${PIO_VERSION}-incubating.tar.gz -C / \
#     && rm apache-predictionio-${PIO_VERSION}-incubating.tar.gz \
#     && cd apache-predictionio-${PIO_VERSION}-incubating \
#     && ./make-distribution.sh

# RUN tar zxvf /apache-predictionio-${PIO_VERSION}-incubating/PredictionIO-${PIO_VERSION}-incubating.tar.gz -C /
# RUN rm -r /apache-predictionio-${PIO_VERSION}-incubating
# RUN mkdir /${PIO_HOME}/vendors
# COPY files/pio-env.sh ${PIO_HOME}/conf/pio-env.sh

# RUN curl -O http://d3kbcqa49mib13.cloudfront.net/spark-${SPARK_VERSION}-bin-hadoop2.6.tgz \
#     && tar -xvzf spark-${SPARK_VERSION}-bin-hadoop2.6.tgz -C ${PIO_HOME}/vendors \
#     && rm spark-${SPARK_VERSION}-bin-hadoop2.6.tgz

# RUN curl -O https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz \
#     && tar -xvzf elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz -C ${PIO_HOME}/vendors \
#     && rm elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz \
#     && echo 'cluster.name: predictionio' >> ${PIO_HOME}/vendors/elasticsearch-${ELASTICSEARCH_VERSION}/config/elasticsearch.yml \
#     && echo 'network.host: 127.0.0.1' >> ${PIO_HOME}/vendors/elasticsearch-${ELASTICSEARCH_VERSION}/config/elasticsearch.yml

# RUN curl -O http://archive.apache.org/dist/hbase/hbase-${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz \
#     && tar -xvzf hbase-${HBASE_VERSION}-bin.tar.gz -C ${PIO_HOME}/vendors \
#     && rm hbase-${HBASE_VERSION}-bin.tar.gz
# COPY files/hbase-site.xml ${PIO_HOME}/vendors/hbase-${HBASE_VERSION}/conf/hbase-site.xml
# RUN sed -i "s|VAR_PIO_HOME|${PIO_HOME}|" ${PIO_HOME}/vendors/hbase-${HBASE_VERSION}/conf/hbase-site.xml \
#     && sed -i "s|VAR_HBASE_VERSION|${HBASE_VERSION}|" ${PIO_HOME}/vendors/hbase-${HBASE_VERSION}/conf/hbase-site.xml
