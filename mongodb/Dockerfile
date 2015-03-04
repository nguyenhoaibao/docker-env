FROM centos:6.6

MAINTAINER baonh <nhbao.la@gmail.com>

RUN yum update -y
RUN yum install curl openssh-server python-setuptools -y
RUN easy_install supervisor

# Copy mongodb repo
COPY ./mongodb.repo /etc/yum.repos.d/mongodb.repo
# Copy config mongodb
COPY ./mongod.conf /etc/mongod.conf
# Install mongodb
RUN yum install mongodb-org -y

# Copy config supervisor
COPY ./supervisord.conf /etc/

RUN mkdir -p /data /var/log/mongodb /var/log/supervisor /var/run/sshd /var/run/mongodb/

VOLUME [ "/data" ]
VOLUME [ "/var/log" ]

EXPOSE 27017 22

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf", "-n"]
