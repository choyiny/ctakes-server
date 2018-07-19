# Official Maven with JDK8
FROM maven:3.5.4-jdk-8-alpine

RUN apk update && apk add unzip

## Download all ctakes files
ADD apache-ctakes-4.0.0-bin.tar.gz /
COPY ctakes-resources-4.0-bin.zip /

RUN ln -s /apache-ctakes-4.0.0 /apache-ctakes

RUN unzip ctakes-resources-4.0-bin.zip
RUN cp -a resources /apache-ctakes/resources

COPY sno_rx_16ab /apache-ctakes/resources/org/apache/ctakes/dictionary

RUN rm ctakes-resources-4.0-bin.zip
RUN rm -rf sno_rx_16ab

WORKDIR /app
RUN mkdir src
ADD src /app/src
ADD pom.xml /app

RUN ln -s ../apache-ctakes/resources resources
RUN ln -s ../apache-ctakes/desc desc

ARG port
ARG umls_id
ARG umls_pw

RUN mvn package

EXPOSE $port

CMD ["java -Dctakes.umlsuser=$umls_id -Dctakes.umlspw=$umls_pw -Xmx5g -cp target/ctakes-server-0.1.jar:resources/ de.dfki.lt.ctakes.Server $host $port desc/ctakes-clinical-pipeline/desc/analysis_engine/AggregatePlaintextFastUMLSProcessor.xml"]
