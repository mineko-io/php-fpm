# php-fpm docker image
Custom php-fpm docker image based on latest php version 7.3

## Enabled php extensions:
* iconv 
* gd
* curl
* bcmath
* json
* mbstring
* pdo_mysql
* opcache
* readline
* xml
* intl
* gettext
* opcache
* exif
* calendar
* mysqli
* sodium
* apcu

## Build
```bash
docker build -t php-fpm .
```
