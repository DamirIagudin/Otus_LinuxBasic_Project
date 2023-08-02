#!/bin/bash

# Создаем 3 директории, в которых будут лежать веб-страницы для каждого сайта
mkdir /var/www/{8080..8082}

# Копируем уже готовые страницы сайтов с разным содежимым для apache 
cp /home/damir/Otus_LinuxBasic_Project/html8080.html /var/www/8080/index.html
cp /home/damir/Otus_LinuxBasic_Project/html8081.html /var/www/8081/index.html
cp /home/damir/Otus_LinuxBasic_Project/html8082.html /var/www/8082/index.html

# Копируем уже готовые файла конфигурации виртуального хостинга (для обращения к каждому порту) в директорию /etc/apache2/sites-available/
cp /home/damir/Otus_LinuxBasic_Project/{8080..8082}.conf /etc/apache2/sites-available

# Включем конфиги в конфигурацию, по сути создаем символические ссылки. 
#(Этим процедура настройки для Debian и Ubuntu отличается от настройки для CentOS)
a2ensite {8080..8082}.conf

# Подменяем (копируем) /etc/apache2/ports.conf в котором прописаны номера портов для обращения Apache. 
cp /home/damir/Otus_LinuxBasic_Project/ports.conf /etc/apache2/ports.conf

# Выполняем reload процесса apache2, чтобы применить новую конфигурацию:
systemctl reload apache2