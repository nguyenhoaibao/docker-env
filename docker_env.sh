#/bin/bash
set -e

DIR="$( cd "$( dirname "$0" )" && pwd )"
APPS=${APPS:-/c/Users/nhbao/Projects/}

killz(){
	echo "Killing all docker containers:"
	docker kill $(docker ps --no-trunc -aq)
	docker rm $(docker ps --no-trunc -aq)
}

stop(){
	echo "Stopping all docker containers:"
	docker stop $(docker ps --no-trunc -aq)
}

init(){
	ELASTICSEARCH=$(docker run \
		-p 9200:9200 \
		-p 5601:5601 \
		-v $APPS/docker_persistent/elasticsearch/data:/data \
		-v $APPS/docker_persistent/elasticsearch/logs:/var/log/elasticsearch \
		--name docker.es.server \
		-d \
		baonh/centos-elasticsearch:v1)
	echo "Started ELASTICSEARCH in container $ELASTICSEARCH"

	MONGO=$(docker run \
		-p 27017:27017 \
		-v $APPS/docker_persistent/mongodb/data:/data \
		-v $APPS/docker_persistent/mongodb/logs:/var/log/mongodb \
		--name docker.mongodb.server \
		-d \
		baonh/centos-mongodb:v1)
	echo "Started MONGO in container $MONGO"
	
	echo "Start app"
	docker run \
		-p 1337:1337 \
		-p 1338:1338 \
		-v $APPS:/srv/www/ \
		--name docker.nodejs \
		--link docker.es.server:docker.es.server \
		--link docker.mongodb.server:docker.mongodb.server \
		-ti \
		baonh/centos-nodejs:v1 \
		/bin/bash

}

start(){
	docker start docker.es.server
	docker start docker.mongodb.server
	docker start docker.nodejs
	docker exec -ti docker.nodejs /bin/bash
}

enter(){
	docker exec -ti docker.nodejs /bin/bash
}

update(){
  
	docker pull baonh/centos-elasticsearch
	docker pull baonh/centos-mongodb
	docker pull baonh/centos-nodejs
	
}

case "$1" in
	restart)
		stop
		start
		;;
	init)
		init
		;;
	start)
		start
		;;
	stop)
		stop
		;;
	enter)
		enter
		;;
	update)
		update
		;;
	status)
		docker ps
		;;
	*)
		echo $"Usage: $0 {start|enter|stop|kill|update|restart|status}"
		RETVAL=1
esac
