FROM ubuntu:22.04


RUN  apt update \
&& apt --yes upgrade \
&& apt --yes install software-properties-common \
&& add-apt-repository universe

RUN apt-get install openjdk-8-jdk wget unzip  --assume-yes


ARG ARCHIVE_URL=http://maven.in2p3.fr/fr/in2p3/lavoisier/lavoisier-package/2.2.2-SNAPSHOT/lavoisier-package-2.2.2-20230414.104000-38-bin.zip


WORKDIR /opt
RUN wget ${ARCHIVE_URL} -O lavoisier.zip -q
RUN unzip -q lavoisier.zip && rm lavoisier.zip
RUN mv lavoisier-* lavoisier
EXPOSE 8080/tcp

 #RUN apk update && apk upgrade && apk add --no-cache git bash
 RUN apt update && apt install --assume-yes git bash-completion vim
 ENV APP_ROOT=/opt/lavoisier
 WORKDIR ${APP_ROOT}

 RUN mkdir logs
 RUN chmod 777 logs
 ADD . ${APP_ROOT}

 #RUN mv ${APP_ROOT}/etc/app/resources/mssql-jdbc-10.2.0.jre8.jar ${APP_ROOT}/lib
 #ENV CLASSPATH_PREFIX=${APP_ROOT}/lib/mssql-jdbc-10.2.0.jre8.jar

 CMD  nohup sh ${APP_ROOT}/bin/lavoisier-start-console.sh > ${APP_ROOT}/logs/lavoisier.log

