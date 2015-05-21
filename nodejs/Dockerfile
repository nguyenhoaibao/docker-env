FROM centos:6.6

MAINTAINER baonh <nhbao.la@gmail.com>

RUN yum update -y
RUN yum install tar curl telnet -y

# Copy nvm script
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.25.2/install.sh | bash && \
	source /root/.bashrc && \
	nvm install stable && \
	nvm alias default stable && \
	nvm install iojs && \
	npm install -g nodemon && \
	npm install -g jshint && \
	npm install -g forever && \
	npm install -g pm2 && \
	mkdir -p /srv/www
