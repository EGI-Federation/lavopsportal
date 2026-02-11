FROM ubuntu:22.04


RUN apt update \
    && apt --yes upgrade \
    && apt --yes install software-properties-common \
    && add-apt-repository universe \
    && apt-get install --assume-yes openjdk-8-jdk unzip git vim curl \
    && rm -rf /var/lib/apt/lists/*

ARG ARCHIVE_URL=http://maven.in2p3.fr/fr/in2p3/lavoisier/lavoisier-package/2.2.2-SNAPSHOT/lavoisier-package-2.2.2-20230414.104000-38-bin.zip

WORKDIR /opt
RUN adduser -u 1000 lavoisier && chown lavoisier /opt
USER lavoisier
# RUN wget ${ARCHIVE_URL} -O lavoisier.zip -q
COPY lavoisier-package-2.2.3-SNAPSHOT-bin.zip lavoisier.zip
RUN unzip -q lavoisier.zip && rm lavoisier.zip
RUN mv lavoisier-* lavoisier
RUN chown -R lavoisier /opt
EXPOSE 8080/tcp

ENV APP_ROOT=/opt/lavoisier
WORKDIR ${APP_ROOT}

RUN mkdir logs
RUN chmod 777 logs
ADD --chown=lavoisier . ${APP_ROOT}

#RUN mv ${APP_ROOT}/etc/app/resources/mssql-jdbc-10.2.0.jre8.jar ${APP_ROOT}/lib
#ENV CLASSPATH_PREFIX=${APP_ROOT}/lib/mssql-jdbc-10.2.0.jre8.jar

CMD  nohup sh ${APP_ROOT}/bin/lavoisier-start-console.sh > ${APP_ROOT}/logs/lavoisier.log

