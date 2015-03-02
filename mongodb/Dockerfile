FROM centos:6.6

MAINTAINER baonh <nhbao.la@gmail.com>

RUN yum update -y
RUN yum install curl -y

# Copy mongodb repo
ADD ./mongodb.repo /etc/yum.repos.d/mongodb.repo

RUN yum install mongodb-org -y

# Copy config mongodb
ADD ./mongod.conf /etc/mongod.conf


RUN mkdir /data
RUN mkdir /logs

RUN chown -R mongod:mongod /data
RUN chown -R mongod:mongod /logs

USER mongod


VOLUME [ "/data" ]
VOLUME [ "/logs" ]


EXPOSE 27017

ENTRYPOINT ["/usr/bin/mongod"]
CMD ["-f", "/etc/mongod.conf"]

