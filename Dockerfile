FROM debian:latest

# Inspired by https://www.jeedom.com/doc/documentation/howto/fr_FR/doc-howto-installation.openjabnab.html

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    ssh \
    apache2 \
    php5 \
    php5-mysql \
    libapache2-mod-php5 \
    make \
    build-essential \
    qt4-dev-tools \
#    bind9 \
    git \
    && apt-get install -y libqt4-dev --fix-missing \
    && rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite

RUN mkdir -p /home/ojn
RUN git clone https://github.com/OpenJabNab/OpenJabNab.git /home/ojn/OpenJabNab \
    && chmod 0777 /home/ojn/OpenJabNab/http-wrapper/ojn_admin/include

COPY ./apache.conf /etc/apache2/sites-available/ojn.conf
RUN a2ensite ojn

RUN cd /home/ojn/OpenJabNab/server \
    && qmake -r \
    && make \
    cp openjabnab.ini-dist bin/openjabnab.ini

CMD ["apache2","-DFOREGROUND"]
