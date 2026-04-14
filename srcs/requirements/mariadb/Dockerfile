FROM debian:bullseye

RUN	apt-get update  -y && apt-get upgrade -y && \  
	apt-get install -y mariadb-server 

RUN mkdir -p run/mysqld && chown -R mysql:mysql /run/mysqld 

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY tools/setup.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/setup.sh"]


