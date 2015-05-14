#/bin/bash
set -e

DIR="$( cd "$( dirname "$0" )" && pwd )"
APPS=${APPS:-/c/Users/nhbao/Projects/}
NS="baonh"

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

stop(){
	echo "Stopping all docker containers:"
	docker stop $(docker ps --no-trunc -aq)
}

create(){
	docker_images=`docker images -aq | wc -l`
	if [ "$docker_images" -eq 0 ];then
		build
	fi
	
	echo "===========  Create elasticsearch container  ==========="
	ELASTICSEARCH=$(docker create \
		-p 9200:9200 \
		-p 5601:5601 \
		-v /data \
		-v /var/log/elasticsearch \
		--name docker.es.server \
		$NS/centos-elasticsearch)
	echo "===========  Created ELASTICSEARCH in container $ELASTICSEARCH  ==========="
	
	echo "===========  Create mongodb container  ==========="
	MONGO=$(docker create \
		-p 27017:27017 \
		-v /data \
		-v /var/log/mongodb \
		--name docker.mongodb.server \
		$NS/centos-mongodb)
	echo "===========  Created MONGO in container $MONGO  ==========="
	
	echo "===========  Create nodejs container  ==========="
	NODEJS=$(docker create \
		-p 1337:1337 \
		-p 1338:1338 \
		-v $APPS:/srv/www/ \
		--name docker.nodejs \
		--link docker.es.server:docker.es.server \
		--link docker.mongodb.server:docker.mongodb.server \
		-ti \
		$NS/centos-nodejs \
		/bin/bash)
	echo "===========  Created NODEJS in container $NODEJS  ==========="
}

build(){
	echo "===========  Build elasticsearch image  ==========="
	docker build -t $NS/centos-elasticsearch elasticsearch/
	echo "Done"
	sleep 5
	echo "===========  Build mongodb image  ==========="
	docker build -t $NS/centos-mongodb mongodb/
	echo "Done"
	sleep 5
	echo "===========  Build nodejs image  ==========="
	docker build -t $NS/centos-nodejs nodejs/
	echo "Done"
}

enter(){
	docker exec -ti docker.nodejs /bin/bash
}

update(){
	docker pull $NS/centos-elasticsearch
	docker pull $NS/centos-mongodb
	docker pull $NS/centos-nodejs
}

killz(){
	echo "Killing all docker containers"
	docker rm -f $(docker ps --no-trunc -aq)
}

case "$1" in
	start)
		start
		;;
	stop)
		stop
		;;
	restart)
		stop
		start
		;;
	build)
		build
		;;
	enter)
		enter
		;;
	update)
		update
		;;
	status)
		docker ps -aq --no-trunc
		;;
	killz)
		killz
		;;
	*)
		echo $"Usage: $0 {start|stop|restart|build|enter|update|status}"
		RETVAL=1
esac
