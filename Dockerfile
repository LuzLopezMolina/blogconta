# Usa la imagen base de PHP
FROM php:8.3-fpm

# Instala las dependencias necesarias
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Configura el directorio de trabajo
WORKDIR /var/www/html

# Copia el composer.json y el composer.lock
COPY composer.json composer.lock ./

# Instala Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Instala las dependencias de Composer
RUN composer install

# Copia el resto del proyecto
COPY . .

# Configura el entorno
ENV WWWGROUP=1000

# Crear el grupo y usuario para ejecutar la aplicación
RUN groupadd --force -g $WWWGROUP sail
RUN useradd -m sail -g sail
