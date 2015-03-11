FROM centos:6.6

MAINTAINER baonh <nhbao.la@gmail.com>

RUN yum update -y
RUN yum install curl openssh-server python-setuptools -y

# Install supervisor
RUN easy_install supervisor

# See http://www.itbakery.net/docker-on-centos-7/
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config
RUN sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config

# Copy mongodb repo
COPY ./mongodb.repo /etc/yum.repos.d/mongodb.repo
# Copy config mongodb
COPY ./mongod.conf /etc/mongod.conf
# Install mongodb
RUN yum install mongodb-org -y

# Copy config supervisor
COPY ./supervisord.conf /etc/

RUN mkdir -p /data /var/log/mongodb /var/log/supervisor /var/run/sshd /var/run/mongodb/

# Change root password to login by ssh
RUN echo 'root:123456' | chpasswd

VOLUME [ "/data" ]
VOLUME [ "/var/log/mongodb" ]

EXPOSE 27017 22

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf", "-n"]
