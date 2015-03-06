FROM centos:6.6

MAINTAINER baonh <nhbao.la@gmail.com>

RUN yum update -y
RUN yum install curl wget tar java-1.7.0-openjdk openssh-server python-setuptools which gcc make -y

# Install supervisor
RUN easy_install supervisor

# See http://www.itbakery.net/docker-on-centos-7/
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config
RUN sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config

# Copy config supervisor
COPY ./supervisord.conf /etc/

# Install elasticsearch
RUN wget --no-check-certificate https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.4.tar.gz -O elasticsearch.tar.gz
RUN	tar -xf elasticsearch.tar.gz
RUN	mv elasticsearch-* elasticsearch
RUN	mv elasticsearch /usr/share
RUN /usr/share/elasticsearch/bin/plugin --install lmenezes/elasticsearch-kopf/master

COPY ./elasticsearch.yml /usr/share/elasticsearch/config/

RUN mkdir -p /data /var/log/supervisor /var/run/sshd /var/log/elasticsearch

# Change root password to login by ssh
RUN echo 'root:123456' | chpasswd

VOLUME [ "/data" ]
VOLUME [ "/var/log" ]

EXPOSE 9200 22

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf", "-n"]
