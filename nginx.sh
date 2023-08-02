#!/bin/bash

# В директорию /etc/nginx/sites-available/ копирует готовый файл конфигурации balance-server.conf.
cp /home/damir/Otus_LinuxBasic_Project/balance-server.conf /etc/nginx/sites-available/

# Чтобы включить файл balance-server.conf в конфигурацию создаем на него символьную ссылку (SoftLink) в папке /etc/nginx/sites-enabled/
ln -s /etc/nginx/sites-available/balance-server.conf /etc/nginx/sites-enabled/balance-server.conf
 
# имеющуюся по умолчанию символьную ссылку на конфигурационный файл файл /etc/nginx/sites-enabled/default удаляем
rm /etc/nginx/sites-enabled/default

# Делаем релоад nginx
service nginx reload
