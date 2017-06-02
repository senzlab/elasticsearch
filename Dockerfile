FROM ubuntu:14.04

MAINTAINER Eranga Bandara (erangaeb@gmail.com)

# install java and other required packages
RUN apt-get update -y
RUN apt-get install -y python-software-properties
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update -y

# install java
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN apt-get install -y oracle-java8-installer
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /var/cache/oracle-jdk7-installer

# set JAVA_HOME
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# elasticserach version
ENV ELASTIC_PKG elasticsearch-5.2.1 

# download and install elasticsearch
RUN cd /
RUN wget https://artifacts.elastic.co/downloads/elasticsearch/${ELASTIC_PKG}.tar.gz
RUN tar xvzf ${ELASTIC_PKG}.tar.gz
RUN rm -f ${ELASTIC_PKG}.tar.gz
RUN mv /$ELASTIC_PKG /elasticsearch

# running port
EXPOSE 9200 9300

# add elastisearch config 
ADD elasticsearch.yml /elasticsearch/config/elasticsearch.yml 

# as a volume at the end
VOLUME ["/data"]

# start elasticsearch
CMD ["/elasticsearch/bin/elasticsearch"] 
