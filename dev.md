# useful commands
## clean up docker 
```
docker system prune -f
```

## build container with no cache
```
docker-compose build --no-cache
```
## start iris container
```
docker-compose up -d
```

## open terminal to docker
```
docker-compose exec iris iris session iris -U IRISAPP
```

## install docker-compose
```
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

```

## select zpm test registry
```
repo -n registry -r -url https://test.pm.community.intersystems.com/registry/ -user test -pass PassWord42
```


