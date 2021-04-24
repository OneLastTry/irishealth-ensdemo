#ARG IMAGE=store/intersystems/irishealth-community:2019.4.0.383.0
#ARG IMAGE=store/intersystems/irishealth-community:2020.1.0.202.0
#ARG IMAGE=store/intersystems/irishealth-community:2020.2.0.211.0
ARG IMAGE=store/intersystems/irishealth-community:2021.1.0.205.0
FROM $IMAGE AS IRISHealthIAMBuilder
LABEL maintainer="Renan Lourenco <renan.lourenco@intersystems.com>"

USER ${ISC_PACKAGE_MGRUSER}
ENV IRIS_PASSWORD="SYS"
ENV IRIS_INSTALLER="/tmp/Installer.cls"

COPY ./Installer.cls /tmp/Installer.cls
COPY ./demo/cls /tmp/demo/cls
COPY scripts /tmp/scripts

USER root

RUN chown -R ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /tmp/scripts \
    && chmod +x /tmp/scripts/build.sh

# Switch user back to IRIS owner and load initialization code and run
USER ${ISC_PACKAGE_MGRUSER}
SHELL ["/tmp/scripts/build.sh"]

# Install custom code
RUN \
  zn "%SYS" \
  set sc = $SYSTEM.OBJ.Load("/tmp/Installer.cls","ck") \
  if sc do ##class(ENSDEMO.Installer).Install("/tmp/demo/cls")
SHELL ["/bin/bash", "-c"]

RUN echo "$IRIS_PASSWORD" >> /tmp/pwd.isc && /usr/irissys/dev/Container/changePassword.sh /tmp/pwd.isc

# 2nd stage to reduce size
FROM $IMAGE AS IRISHealthIAMDemo
LABEL maintainer "Renan Lourenço <renan.lourenco@intersystems.com>"
USER root
# replace in standard kit with what we modified in first stage
COPY --from=IRISHealthIAMBuilder /usr/irissys/iris.cpf /usr/irissys/.
COPY --from=IRISHealthIAMBuilder /usr/irissys/mgr/IRIS.DAT /usr/irissys/mgr/.
COPY --from=IRISHealthIAMBuilder /usr/irissys/mgr/hssys/IRIS.DAT /usr/irissys/mgr/hssys/.
COPY --from=IRISHealthIAMBuilder /usr/irissys/mgr/ensdemo/. /usr/irissys/mgr/ensdemo/.
COPY ./demo/csp /usr/irissys/csp/healthshare/ensdemo/
# need to reset ownership for files copied
RUN \
  chown -R ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /usr/irissys/iris.cpf \
  && chown -R ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /usr/irissys/mgr/IRIS.DAT \
  && chown -R ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /usr/irissys/mgr/ensdemo \
  && chown -R ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /usr/irissys/mgr/hssys/IRIS.DAT \
  && chmod -R 775 /usr/irissys/mgr/ensdemo/IRIS.DAT