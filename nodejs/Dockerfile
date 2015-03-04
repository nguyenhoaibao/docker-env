FROM centos:6.6

MAINTAINER baonh <nhbao.la@gmail.com>

RUN yum update -y
RUN yum install tar curl openssh-clients -y

COPY ./install.sh /root/

RUN chmod a+x /root/install.sh && \
  /bin/bash /root/install.sh && \
  source /root/.bashrc && \
  nvm install stable && \
  nvm alias default stable
