#/bin/bash
set -e

DIR="$( cd "$( dirname "$0" )" && pwd )"
APPS=${APPS:-/c/Users/nhbao/Projects/}

killz(){
	echo "Killing all docker containers:"
	docker ps -aq
	docker kill $(docker ps --no-trunc -aq)
	docker rm $(docker ps --no-trunc -aq)
}

stop(){
	echo "Stopping all docker containers:"
	docker ps -aq
	docker stop $(docker ps --no-trunc -aq)
	docker rm $(docker ps --no-trunc -aq)
}

start(){
	ELASTICSEARCH=$(docker run \
		-p 9200:9200 \
		-p 5601:5601 \
		--name docker.es.server \
		-d \
		baonh/centos-elasticsearch:v1)
	echo "Started ELASTICSEARCH in container $ELASTICSEARCH"

	MONGO=$(docker run \
		-p 27017:27017 \
		--name docker.mongodb.server \
		-d \
		baonh/centos-mongodb:v1)
	echo "Started MONGO in container $MONGO"

	sleep 1

}

start-web(){
	docker run \
		-p 1337:1337 \
		-p 1338:1338 \
		-v $APPS:/srv/www/ \
		--name docker.nodejs \
		--link docker.es.server:docker.es.server \
		--link docker.mongodb.server:docker.mongodb.server \
		-ti \
		baonh/centos-nodejs:v1
}

update(){
  
	docker pull baonh/centos-elasticsearch
	docker pull baonh/centos-mongodb
	docker pull baonh/centos-nodejs
	
}

case "$1" in
	restart)
		killz
		start
		;;
	start)
		start
		;;
	start-web)
		start-web
		;;
	stop)
		stop
		;;
	kill)
		killz
		;;
	update)
		update
		;;
	status)
		docker ps
		;;
	*)
		echo $"Usage: $0 {start|stop|kill|update|restart|status}"
		RETVAL=1
esac
