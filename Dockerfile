FROM debian:stable

# Pre configuration de postfix
RUN echo "postfix postfix/mailname string docker.bowlman.org" | debconf-set-selections
RUN echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

# Pre configuration de mysql-serveur
RUN echo "mysql-server mysql-server/root_password password tttttt" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password tttttt" | debconf-set-selections

# Pre configuration de phpmyadmin
RUN echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
RUN echo "phpmyadmin phpmyadmin/app-password-confirm password tttttt" | debconf-set-selections
RUN echo "phpmyadmin phpmyadmin/mysql/admin-pass password tttttt" | debconf-set-selections
RUN echo "phpmyadmin phpmyadmin/mysql/app-pass password tttttt" | debconf-set-selections
RUN echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections

# Installation des paquets necessaires
RUN apt-get -y update && apt-get install -y apache2 expect php5 php5-mysql mysql-server nano postfix
RUN service apache2 restart
RUN service mysql restart

# Lancement automatique de apache2
RUN echo "/etc/init.d/apache2 restart" >> /etc/bash.bashrc
RUN echo "/etc/init.d/mysql restart" >> /etc/bash.bashrc
RUN echo "apt-get -y install phpmyadmin" >> /etc/bash.bashrc
RUN echo "/etc/init.d/apache2 restart" >> /etc/bash.bashrc

RUN a2enmod rewrite
RUN sed "/s/AllowOverride None/AllowOverride All/g" /etc/apache2/site-available/000-default.conf

RUN cat /etc/apache2/site-available/000-default.conf

