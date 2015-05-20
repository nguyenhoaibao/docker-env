#/bin/bash
set -e

DIR="$( cd "$( dirname "$0" )" && pwd )"
APPS=${APPS:-/c/Users/nhbao/Projects/}
NAMESPACE="baonh"
ES_IMAGE_NAME="centos-elasticsearch"
ES_CONTAINER_NAME="docker.es.server"
MONGODB_IMAGE_NAME="centos-mongodb"
MONGODB_CONTAINER_NAME="docker.mongodb.server"
NODEJS_IMAGE_NAME="centos-nodejs"
NODEJS_CONTAINER_NAME="docker.nodejs"
NGINX_IMAGE_NAME="centos-nginx"
NGINX_CONTAINER_NAME="docker.nginx.server"
PHPFPM_IMAGE_NAME="centos-php-fpm"
PHPFPM_CONTAINER_NAME="docker.php-fpm.server"

start(){
	docker_running=`docker ps -aq | wc -l`
	if [ "$docker_running" -eq 0 ];then
		create
	fi

	docker start $ES_CONTAINER_NAME
	docker start $MONGODB_CONTAINER_NAME
	docker start $NODEJS_CONTAINER_NAME
	docker exec -ti $NODEJS_CONTAINER_NAME /bin/bash
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
		--name $ES_CONTAINER_NAME \
		$NAMESPACE/$ES_IMAGE_NAME)
	echo "===========  Created ELASTICSEARCH in container $ELASTICSEARCH  ==========="
	
	echo "===========  Create mongodb container  ==========="
	MONGO=$(docker create \
		-p 27017:27017 \
		-v /data \
		-v /var/log/mongodb \
		--name $MONGODB_CONTAINER_NAME \
		$NAMESPACE/$MONGODB_IMAGE_NAME)
	echo "===========  Created MONGO in container $MONGO  ==========="
	
	echo "===========  Create nodejs container  ==========="
	NODEJS=$(docker create \
		-p 1337:1337 \
		-p 1338:1338 \
		-v $APPS:/srv/www/ \
		--name $NODEJS_CONTAINER_NAME \
		--link $ES_CONTAINER_NAME:$ES_CONTAINER_NAME \
		--link $MONGODB_CONTAINER_NAME:$MONGODB_CONTAINER_NAME \
		-ti \
		$NAMESPACE/$NODEJS_IMAGE_NAME \
		/bin/bash)
	echo "===========  Created NODEJS in container $NODEJS  ==========="
}

build(){
	echo "===========  Build elasticsearch image  ==========="
	docker build -t $NAMESPACE/$ES_IMAGE_NAME elasticsearch/
	echo "Done"
	sleep 5
	echo "===========  Build mongodb image  ==========="
	docker build -t $NAMESPACE/$MONGODB_IMAGE_NAME mongodb/
	echo "Done"
	sleep 5
	echo "===========  Build nodejs image  ==========="
	docker build -t $NAMESPACE/$NODEJS_IMAGE_NAME nodejs/
	echo "Done"
	echo "===========  Build nginx image  ==========="
	docker build -t $NAMESPACE/$NGINX_IMAGE_NAME nginx/
	echo "Done"
	echo "===========  Build php-fpm image  ==========="
	docker build -t $NAMESPACE/$PHPFPM_IMAGE_NAME php-fpm/
	echo "Done"
}

enter(){
	docker exec -ti $NODEJS_CONTAINER_NAME /bin/bash
}

update(){
	docker pull $NAMESPACE/$ES_IMAGE_NAME
	docker pull $NAMESPACE/$MONGODB_IMAGE_NAME
	docker pull $NAMESPACE/$NODEJS_IMAGE_NAME
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
