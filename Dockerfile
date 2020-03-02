FROM ubuntu:18.04
LABEL name="docker-ci"

ENV TZ=UTC

RUN export LC_ALL=C.UTF-8
RUN DEBIAN_FRONTEND=noninteractive
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update
RUN apt-get install -y \
    sudo \
    autoconf \
    autogen \
    language-pack-en-base \
    wget \
    zip \
    unzip \
    curl \
    rsync \
    ssh \
    openssh-client \
    git \
    build-essential \
    apt-utils \
    software-properties-common \
    nasm \
    libjpeg-dev \
    libpng-dev \
    libpng16-16

RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

# Chrome
RUN echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' > /etc/apt/sources.list.d/chrome.list

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -

RUN set -x \
    && apt-get update \
    && apt-get install -y \
        google-chrome-stable

ENV CHROME_BIN /usr/bin/google-chrome

# Python
RUN set -x \
    && apt-get install -y \
        python3-pip

RUN pip3 install requests urllib3 pyOpenSSL docopt slackclient jira GitPython acapi psutil

# PHP
RUN LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php && apt-get update && apt-get install -y php7.4
RUN apt-get install -y \
    php7.4-curl \
    php7.4-gd \
    php7.4-dev \
    php7.4-xml \
    php7.4-bcmath \
    php7.4-mysql \
    php7.4-pgsql \
    php7.4-mbstring \
    php7.4-zip \
    php7.4-bz2 \
    php7.4-sqlite \
    php7.4-soap \
    php7.4-json \
    php7.4-intl \
    php7.4-imap \
    php7.4-imagick \
    php-memcached

ENV PHP_VERSION 7.4

# Composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer \
    && composer self-update --preview

# Node
RUN curl -sL https://deb.nodesource.com/setup_13.x | bash -
RUN set -x \
    && apt-get install -y \
        nodejs

# Lighthouse
RUN set -x \
    && npm i -g lighthouse

# Log versions
RUN set -x \
    && export \
    && python3 --version \
    && pip3 --version \
    && pip3 list \
    && node -v \
    && php -v \
    && npm -v \
    && google-chrome --version
