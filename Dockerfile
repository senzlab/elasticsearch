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

# add user to avoid starting elasticsearch as root user
#RUN useradd -d /home/esuser -m esuser -u 1000
RUN groupadd -g 1000 esuser 
RUN useradd esuser -u 1000 -g 1000 -d /home/esuser 

WORKDIR /home/esuser

# as a volume at the end
RUN mkdir data
VOLUME ["/home/esuser/data"]

# download and install elasticsearch
RUN wget https://artifacts.elastic.co/downloads/elasticsearch/${ELASTIC_PKG}.tar.gz
RUN tar xvzf ${ELASTIC_PKG}.tar.gz
RUN rm -f ${ELASTIC_PKG}.tar.gz
RUN mv /home/esuser/$ELASTIC_PKG /home/esuser/elasticsearch

# running port
EXPOSE 9200 9300

# add elastisearch config 
ADD elasticsearch.yml /home/esuser/elasticsearch/config/elasticsearch.yml 

# run elastic search as senzuser
RUN chown -R 1000:1000 /home/esuser/elasticsearch 
RUN chown -R 1000:1000 /home/esuser/data 

USER esuser

# start elasticsearch
CMD ["/home/esuser/elasticsearch/bin/elasticsearch"] 
