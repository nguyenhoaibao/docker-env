FROM centos:6.6

MAINTAINER baonh <nhbao.la@gmail.com>

RUN yum update -y
#RUN yum install curl openssh-server python-setuptools -y

# Install supervisor
#RUN easy_install supervisor
# Copy config supervisor
#COPY ./supervisord.conf /etc/

# See http://www.itbakery.net/docker-on-centos-7/
#RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
#RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
#RUN sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config
#RUN sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config

# Copy mongodb repo
COPY ./mongodb.repo /etc/yum.repos.d/mongodb.repo
# Copy config mongodb
COPY ./mongod.conf /etc/mongod.conf
# Copy script to start mongod
COPY ./mongod.sh /etc/mongod.sh
RUN chmod a+x /etc/mongod.sh
# Install mongodb
RUN yum install mongodb-org -y

# Forward error logs to docker log collector
RUN ln -sf /dev/stderr /var/log/mongodb/mongod.log

RUN mkdir -p /data /var/run/mongodb/

# Change root password to login by ssh
#RUN echo 'root:123456' | chpasswd

VOLUME [ "/data" ]

EXPOSE 27017

CMD rm -f /data/mongod.lock && /usr/bin/mongod -f /etc/mongod.conf
