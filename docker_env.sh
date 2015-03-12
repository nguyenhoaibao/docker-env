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

create(){
	ELASTICSEARCH=$(docker create \
		-p 9200:9200 \
		-p 5601:5601 \
		-v /data \
		-v /var/log/elasticsearch \
		--name docker.es.server \
		baonh/centos-elasticsearch:v1)
	echo "Created ELASTICSEARCH in container $ELASTICSEARCH"

	MONGO=$(docker create \
		-p 27017:27017 \
		-v /data \
		-v /var/log/mongodb \
		--name docker.mongodb.server \
		baonh/centos-mongodb:v1)
	echo "Created MONGO in container $MONGO"
	
	NODEJS=$(docker create \
		-p 1337:1337 \
		-p 1338:1338 \
		-v /srv/www/ \
		--name docker.nodejs \
		--link docker.es.server:docker.es.server \
		--link docker.mongodb.server:docker.mongodb.server \
		-ti \
		baonh/centos-nodejs:v1 \
		/bin/bash)
	echo "Created NODEJS in container $NODEJS"
}

start(){
	docker_running=`docker ps -aq | wc -l`
	if [ "$docker_running" -eq 0 ];then

		create
	fi

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
		echo $"Usage: $0 {start|enter|stop|update|restart|status}"
		RETVAL=1
esac
