FROM java:8-alpine

ENV MAVEN_VERSION 3.5.4
ENV MAVEN_HOME /usr/lib/mvn
ENV PATH $MAVEN_HOME/bin:$PATH


RUN wget http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  tar -zxvf apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  rm apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  mv apache-maven-$MAVEN_VERSION /usr/lib/mvn

RUN apk update && apk upgrade && apk add --no-cache bash git
RUN apk add --no-cache git alpine-sdk python-dev py-cffi linux-headers musl-dev python3-dev g++
RUN apk add --no-cache krb5-pkinit krb5-dev krb5 cyrus-sasl-gssapi

WORKDIR /opt
RUN git clone http://gitlab+token_wok:J9mxfe5M299b6jJpNJ3T@gitlab.in2p3.fr/opsportal/lavopsportal.git -b WoK
WORKDIR /opt/lavopsportal

RUN mkdir certificates


### Setup user for build execution and application runtime
ENV APP_ROOT=/opt/lavopsportal
ENV PATH=${APP_ROOT}:${PATH} HOME=${APP_ROOT}

RUN chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /etc/passwd

### Containers should NOT run as root as a good practice
USER 10001
WORKDIR ${APP_ROOT}

RUN sh uidentrypoint
EXPOSE 8080/tcp

CMD mvn exec:java
