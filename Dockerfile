FROM php:8.2-apache

# Enable mod_rewrite
RUN a2enmod rewrite

# Install mysqli extension for PHP
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

# Set working directory
WORKDIR /var/www/html

# Copy all files
COPY . /var/www/html/

# Set permissions
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Use the PORT environment variable from Railway
ENV APACHE_RUN_USER=www-data
ENV APACHE_RUN_GROUP=www-data

# Configure Apache to listen on Railway's dynamic PORT
RUN echo "Listen 8080" >> /etc/apache2/ports.conf && \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    sed -i 's/80/8080/g' /etc/apache2/sites-available/000-default.conf && \
    sed -i 's/80/8080/g' /etc/apache2/ports.conf

# Expose port
EXPOSE 8080

# Start Apache
CMD ["apache2-foreground"]