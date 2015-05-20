FROM centos:6.6

MAINTAINER baonh <nhbao.la@gmail.com>

# Install php
RUN rpm -Uvh http://mirrors.digipower.vn/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
RUN yum --enablerepo=remi,remi-php56 install php-fpm php-common php-cli php-pear php-pdo php-mysqlnd php-pgsql php-pecl-mongo php-sqlite php-pecl-memcache php-pecl-memcached php-gd php-mbstring php-mcrypt php-xml -y

COPY ./www.conf /etc/php-fpm.d/

# Forward error logs to docker log collector
RUN ln -sf /dev/stderr /var/log/php-fpm/www-error.log

EXPOSE 9000

CMD ["php-fpm", "--nodaemonize"]
