#ARG IMAGE=store/intersystems/irishealth-community:2019.4.0.383.0
#ARG IMAGE=store/intersystems/irishealth-community:2020.1.0.202.0
ARG IMAGE=store/intersystems/irishealth-community:2020.2.0.211.0
ARG IMAGE=intersystemsdc/irishealth-community:2020.3.0.200.0-zpm
FROM $IMAGE

LABEL maintainer="Renan Lourenco <renan.lourenco@intersystems.com>"

ENV IRIS_USERNAME="SuperUser"
ENV IRIS_PASSWORD="SYS"
ENV IRIS_PROJECT="/src/"
ENV IRIS_INSTALLER="/tmp/Installer.cls"

# setting the date of the image. modify it as required
#ENV TZ="Asia/Dubai"
#USER root
#RUN apt-get update && \
#    apt-get install -y tzdata && \
#    echo $TZ > /etc/timezone && \
#    dpkg-reconfigure -f noninteractive tzdata

ENV user "irisowner"
USER root
WORKDIR /opt/irisapp
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisapp
USER ${ISC_PACKAGE_MGRUSER}

COPY  Installer.cls .

COPY demo/cls demo/cls
COPY demo/csp /usr/irissys/csp/healthshare/ensdemo/
RUN echo "$IRIS_PASSWORD" >> /tmp/pwd.isc && /usr/irissys/dev/Container/changePassword.sh /tmp/pwd.isc
COPY scripts/iris.script /tmp/iris.script

RUN iris start IRIS \
    && iris session IRIS < /tmp/iris.script \
    && iris stop IRIS quietly
