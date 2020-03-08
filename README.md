# InterSystems IRIS for Health Demo

Basic setup of ENSDEMO content into InterSystems IRIS for Health
**Make sure you have Docker up and running before starting.**

## Setup

Clone the repository to your desired directory

```bash
git clone https://github.com/OneLastTry/irishealth-ensdemo.git
```

Once the repository is clone from command line go to the directory and execute:
**Always make sure you are inside the main directory to execute docker-compose commands.**

```bash
docker-compose build
```

## Run your Container

After building the image you can either simply execut below and you be up and running 🚀:
*-d will run the container deattached of your command line session*

```bash
docker-compose up -d
```

You can now access the manager portal through http://localhost:9092/csp/sys/%25CSP.Portal.Home.zen
**Username:** SuperUser
**Password:** SYS

**SuperServer port:** 9091
**Web port:** 9092

**Namespace:** ENSDEMO

To start a terminal session execute:

```bash
docker exec -it ensdemo iris session iris
```

To start a bash session execute:

```bash
docker exec -it ensdemo /bin/bash
```

Using [InterSystems ObjectScript](https://marketplace.visualstudio.com/items?itemName=daimor.vscode-objectscript) Visual Studio Code pextension, you can access the code straight from _vscode_

## Stop your Container

```bash
docker-compose stop
```
