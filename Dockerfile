FROM google/dart
MAINTAINER Alexey Salnikov <me@iamsalnikov.ru>

COPY . /var/www
RUN cd /var/www && pub get

WORKDIR /var/www
ENTRYPOINT ["/var/www/start.sh"]
