FROM        127.0.0.1:5000/nicescale_ubuntu_base:1.2
RUN         groupadd haproxy -g 80
RUN         useradd haproxy -u 80 -g 80 -M -d /var/lib/haproxy -s /bin/false
RUN         apt-get update
RUN         DEBIAN_FRONTEND=noninteractive apt-get -y install haproxy

CMD         /docker_start.sh service haproxy start
