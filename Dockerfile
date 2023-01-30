FROM gitlab-registry.in2p3.fr/cc-in2p3-devops/openshift-origin/openshift-images/lavoisier:latest
 #RUN apk update && apk upgrade && apk add --no-cache git bash
 RUN apt update && apt install --assume-yes git bash-completion vim
 ENV APP_ROOT=/opt/lavoisier
 WORKDIR ${APP_ROOT}

 RUN mkdir logs
 RUN chmod 777 logs
 ADD . ${APP_ROOT}/etc

 #RUN mv ${APP_ROOT}/etc/app/resources/mssql-jdbc-10.2.0.jre8.jar ${APP_ROOT}/lib
 #ENV CLASSPATH_PREFIX=${APP_ROOT}/lib/mssql-jdbc-10.2.0.jre8.jar

 CMD  nohup sh ${APP_ROOT}/bin/lavoisier-start-console.sh > ${APP_ROOT}/logs/lavoisier.log

