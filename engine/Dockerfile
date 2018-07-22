FROM ubuntu:18.04

RUN mkdir /root/app
WORKDIR /root/app

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# Install system dependencies & utilities
RUN apt-get update
RUN apt-get install -y --auto-remove --no-install-recommends curl openjdk-8-jdk libgfortran3 python3-pip python-setuptools
RUN apt-get install -y dos2unix git vim

ENV PIO_HOME /root/app/PredictionIO-0.12.1

# Build & install Prediction.IO
RUN curl -O http://www-us.apache.org/dist/predictionio/0.12.1/apache-predictionio-0.12.1-bin.tar.gz \
    && mkdir ${PIO_HOME} \
    && tar xvzfC apache-predictionio-0.12.1-bin.tar.gz /root/app

# Add PIO_HOME to environment variables
RUN echo "export PIO_HOME=${PIO_HOME}" >> ~/.bashrc

# Add Prediction.IO binaries to PATH
RUN echo "export PATH=${PIO_HOME}/bin:${PATH}" >> ~/.bashrc \
    && . ~/.bashrc

RUN mkdir ${PIO_HOME}/vendors 

# Download PostgreSQL JDBC driver
RUN curl --url https://jdbc.postgresql.org/download/postgresql-42.2.4.jar --output ${PIO_HOME}/lib/postgresql-42.2.4.jar

# Install Spark
RUN curl -O http://d3kbcqa49mib13.cloudfront.net/spark-2.1.1-bin-hadoop2.6.tgz \
    && tar zxvfC spark-2.1.1-bin-hadoop2.6.tgz ${PIO_HOME}/vendors/

# Configure Prediction.IO
COPY ./dockerfile-config/pio-env.sh ${PIO_HOME}/conf/pio-env.sh
RUN dos2unix ${PIO_HOME}/conf/pio-env.sh

# Make aliases for python & pip
RUN echo "alias python='python3'" >> ~/.bashrc \ 
    && echo "alias pip='pip3'" >> ~/.bashrc \
    && . ~/.bashrc

# Pre-install python modules
COPY ./requirements.txt ./requirements.txt
RUN pip install -r ./requirements.txt

EXPOSE 8000