ARG IMAGE=store/intersystems/irishealth-community:2019.4.0.383.0
FROM $IMAGE

LABEL maintainer="Renan Lourenco <renan.lourenco@intersystems.com>"

ENV IRIS_USERNAME="SuperUser"
ENV IRIS_PASSWORD="SYS"
ENV IRIS_PROJECT="/src/"
ENV IRIS_INSTALLER="/tmp/Installer.cls"

# setting the date of the image. modify it as required
ENV TZ="Asia/Dubai"
USER root
RUN apt-get update && \
    apt-get install -y tzdata && \
    echo $TZ > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata

ENV user "irisowner"
USER irisowner
ADD ./Installer.cls /tmp/Installer.cls
ADD ./demo/cls /tmp/demo/cls
ADD ./scripts/irissession.sh /tmp/irissession.sh
COPY ./demo/csp /usr/irissys/csp/healthshare/ensdemo/
RUN echo "$IRIS_PASSWORD" >> /tmp/pwd.isc && /usr/irissys/dev/Container/changePassword.sh /tmp/pwd.isc

SHELL ["/tmp/irissession.sh"]
RUN \
  do $SYSTEM.OBJ.Load("/tmp/Installer.cls", "ck") \
  set sc = ##class(ENSDEMO.Installer).Install("/tmp/demo/cls")
  
SHELL ["/bin/bash", "-c"]
CMD [ "-l", "/usr/irissys/mgr/messages.log" ]

HEALTHCHECK --interval=5s CMD /irisHealth.sh || exit 1