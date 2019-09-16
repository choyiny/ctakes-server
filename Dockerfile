# Official Maven with JDK8
FROM maven:3.5.4-jdk-8-alpine

RUN apk update && apk add unzip

## Download all ctakes files
ADD http://mirror.csclub.uwaterloo.ca/apache//ctakes/ctakes-4.0.0/apache-ctakes-4.0.0-bin.tar.gz /
ADD https://astuteinternet.dl.sourceforge.net/project/ctakesresources/ctakes-resources-4.0-bin.zip /

RUN tar -xvzf apache-ctakes-4.0.0-bin.tar.gz && \
    ln -s /apache-ctakes-4.0.0 /apache-ctakes && \
    unzip ctakes-resources-4.0-bin.zip && \
    cp -a resources /apache-ctakes/resources && \
    mkdir sno_rx_16ab

ADD https://phoenixnap.dl.sourceforge.net/project/ctakesresources/sno_rx_16ab.zip /sno_rx_16ab
RUN unzip sno_rx_16ab/sno_rx_16ab.zip && \
    mv sno_rx_16ab /apache-ctakes/resources/org/apache/ctakes/dictionary && \
    rm ctakes-resources-4.0-bin.zip && \
    rm -rf sno_rx_16ab

WORKDIR /app
RUN mkdir src

ADD src /app/src
ADD pom.xml /app

RUN ln -s ../apache-ctakes/resources resources && \
    ln -s ../apache-ctakes/desc desc && \
    mvn package
