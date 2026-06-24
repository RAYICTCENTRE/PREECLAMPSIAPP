FROM php:8.2-cli

# Install PHP extensions
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

# Set working directory
WORKDIR /app

# Copy files
COPY . /app/

# Use PHP built-in server
EXPOSE 8080

CMD ["php", "-S", "0.0.0.0:8080", "-t", "/app"]
