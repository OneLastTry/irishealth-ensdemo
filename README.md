# InterSystems IRIS for Health ENSDEMO

Basic setup of ENSDEMO content into InterSystems IRIS for Health.

**Make sure you have Docker up and running before starting.**

[![Demo](https://img.shields.io/badge/Demo%20on-Cloud%20Run%20Deploy-F4A460)](https://irishealth-ensdemo.demo.community.intersystems.com/csp/healthshare/ensdemo/EnsPortal.Productions.zen?$NAMESPACE=ENSDEMO&$NAMESPACE=ENSDEMO)

[![Quality Gate Status](https://community.objectscriptquality.com/api/project_badges/measure?project=OneLastTry%2Firishealth-ensdemo&metric=alert_status)](https://community.objectscriptquality.com/dashboard?id=OneLastTry%2Firishealth-ensdemo)


## Setup

Clone the repo `git clone https://github.com/OneLastTry/irishealth-ensdemo.git` and then execute from the main directory `docker-compose build`.

## Execution

Once the build is complete, from the main directory, start your iris container:

- **start container:** `docker-compose up -d`

## Run your Container

After building the image you can simply execute below and you be up and running 🚀:

*-d will run the container detached of your command line session*

```bash
docker-compose up -d
```

You can now access the manager portal through http://localhost:9092/csp/sys/%25CSP.Portal.Home.zen

- **Username:** SuperUser
- **Password:** SYS
- **SuperServer port:** 9091
- **Web port:** 9092
- **Namespace:** ENSDEMO

![ensdemo](https://openexchange.intersystems.com/mp/img/packages/468/screenshots/zhnwycjrflt4q7gttwsidcntxk.png)

To start a terminal session execute:

```bash
docker exec -it ensdemo iris session iris
```

To start a bash session execute:

```bash
docker exec -it ensdemo /bin/bash
```

Using [InterSystems ObjectScript](https://marketplace.visualstudio.com/items?itemName=daimor.vscode-objectscript) Visual Studio Code extension, you can access the code straight from _vscode_

![vscode](https://openexchange.intersystems.com/mp/img/packages/468/screenshots/bgirfnblz2zym4zi2q92lnxkmji.png)

## Stop your Container

```bash
docker-compose stop
```

## Support to ZPM

```bash
zpm "install irishealth-ensdemo"
```
