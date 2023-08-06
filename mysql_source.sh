#!/bin/bash

#Установка пакета из стандартного репозитория
apt install mysql-server

#По умолчанию было настроено только чтобы слушать localhost.
#должен слушать не только localhost, но и другие адреса! 
#Делаем изменение в конфиг файле: /etc/mysql/mysql.conf.d/mysqld.cnf
sed -i '/mysqlx-bind-address/s/127.0.0.1/0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
