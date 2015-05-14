FROM centos:6.6

MAINTAINER baonh <nhbao.la@gmail.com>

RUN yum update -y
RUN yum install tar curl openssh-clients telnet -y

# Copy nvm script
COPY ./nvm_install.sh /root/

RUN chmod a+x /root/nvm_install.sh && \
  /bin/bash /root/nvm_install.sh && \
  source /root/.bashrc && \
  nvm install stable && \
  nvm alias default stable && \
  npm install -g nodemon && \
  npm install -g jshint && \
  npm install -g forever && \
  npm install -g pm2 && \
  mkdir -p /srv/www

# Define default command
CMD ["bash"]
