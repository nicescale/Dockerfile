FROM        repo.nicescale.com:5000/nicescale_ubuntu_base
RUN         apt-get update
RUN         DEBIAN_FRONTEND=noninteractive apt-get -y install haproxy
ADD         ./docker_start.sh /docker_start.sh
RUN         chmod 500 /docker_start.sh

CMD         /docker_start.sh service haproxy start
