FROM centos:6.6

MAINTAINER baonh <nhbao.la@gmail.com>

RUN yum update -y
RUN yum install curl supervisor openssh-server -y

# Copy mongodb repo
COPY ./mongodb.repo /etc/yum.repos.d/mongodb.repo
# Copy config mongodb
COPY ./mongod.conf /etc/mongod.conf
# Install mongodb
RUN yum install mongodb-org -y

# Copy config supervisor
COPY ./supervisord.conf /etc/

RUN mkdir -p /var/run/sshd
RUN mkdir /data
RUN mkdir /logs

RUN chown -R mongod:mongod /data
RUN chown -R mongod:mongod /logs

USER mongod

VOLUME [ "/data" ]
VOLUME [ "/logs" ]


EXPOSE 27017

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

