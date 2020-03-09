# InterSystems IRIS for Health ENSDEMO

Basic setup of ENSDEMO content into InterSystems IRIS for Health.

**Version:** _store/intersystems/irishealth-community:2019.4.0.383.0_

**Make sure you have Docker up and running before starting.**

## Setup

Clone the repository to your desired directory

```bash
git clone https://github.com/OneLastTry/irishealth-ensdemo.git
```

Once the repository is a clone from command line go to the directory and execute:

**Always make sure you are inside the main directory to execute docker-compose commands.**

```bash
docker-compose build
```

## Run your Container

After building the image you can either simply execut below and you be up and running 🚀:

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

To start a terminal session execute:

```bash
docker exec -it ensdemo iris session iris
```

To start a bash session execute:

```bash
docker exec -it ensdemo /bin/bash
```

Using [InterSystems ObjectScript](https://marketplace.visualstudio.com/items?itemName=daimor.vscode-objectscript) Visual Studio Code extension, you can access the code straight from _vscode_

## Stop your Container

```bash
docker-compose stop
```
