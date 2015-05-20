FROM centos:6.6

MAINTAINER baonh <nhbao.la@gmail.com>

# Copy mongodb repo
COPY ./mongodb.repo /etc/yum.repos.d/mongodb.repo
# Copy config mongodb
COPY ./mongod.conf /etc/mongod.conf
# Install mongodb
RUN yum install mongodb-org -y

RUN mkdir -p /data /var/run/mongodb/

# Forward error logs to docker log collector
RUN ln -sf /dev/stderr /var/log/mongodb/mongod.log

VOLUME [ "/data" ]

EXPOSE 27017

CMD rm -f /data/mongod.lock && /usr/bin/mongod -f /etc/mongod.conf
