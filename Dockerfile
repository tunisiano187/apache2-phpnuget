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
RUN apt-get -y update && apt-get install -y apache2 expect php php-mysql mysql-server nano postfix wget zip
RUN service apache2 restart
RUN service mysql restart

# Prepare apache2 for PHPNuget
RUN a2enmod rewrite
ADD 000-default.conf /etc/apache2/site-available/000-default.conf
RUN wget http://www.kendar.org/?p=/dotnet/phpnuget/phpnuget.zip -O phpnuget.zip
RUN unzip phpnuget.zip
RUN mv src /var/www/html
RUN chown www-data:www-data -R /var/www/html


# Lancement automatique de apache2
RUN echo "/etc/init.d/apache2 restart" >> /etc/bash.bashrc
RUN echo "/etc/init.d/mysql restart" >> /etc/bash.bashrc
RUN echo "apt-get -y install phpmyadmin" >> /etc/bash.bashrc
RUN echo "/etc/init.d/apache2 restart" >> /etc/bash.bashrc

