# Otus_LinuxBasic_Project
Проектная работа по курсу Administrator Linux.Basic.

Порядок действий

1. Находясь в домашней директории клонируем репозиторий с GitHub:
git clone https://github.com/DamirIagudin/Otus_LinuxBasic_Project.git

2. Переходим в директорию Otus_LinuxBasic_Project. Все скрипты запускаем отсюда.
cd Otus_LinuxBasic_Project

3. Настройка вебсервера с балансировкой нагрузки
- установка и конфигурация Apache 
	sudo bash apache.sh 
- установка и конфигурация Nginx
	sudo bash nginx.sh
- проверка открытых сокетов
	sudo ss -ntlp
- проверка работы вебсервер из браузера на адрес 192.168.178.41

4. Настройка системы мониторинга
- установка и конфигурация Prometheus и node_exporter
	sudo bash monitoring.sh
- установка и конфигурация Grafana
	sudo bash grafana.sh 
- проверка открытых сокетов
	sudo ss -ntlp	
- создание в браузере дашборда для мониторинга;
	настройка data_sources:
	http://192.168.178.41:9090
	импорт дашборда 1860
	
	
5. Установка, конфигурация, репликация MySQL. Восстановление из ранее созданного бэкапа.

5.1 Установка, конфигурация MySQL на Source (linux-spec1).
- установка и конфигурация MySQL
	sudo bash mysql_replica.sh 
- создаем пользователя для репликации
	CREATE USER repl@'%' IDENTIFIED WITH 'caching_sha2_password' BY 'oTUSlave#2020'; 
- предоставляем новому пользователю права
	GRANT REPLICATION SLAVE ON *.* TO repl@'%';	
- для настройки репликации на linux-spec2 смотрим текущий binlog MASTER_LOG_FILE='binlog.000008'
	show master status;
	
5.2 Установка, конфигурация MySQL на Replica (linux-spec2).
- установка и конфигурация MySQL
	sudo bash mysql_source.sh 
- на всякий случай делаем стоп репликации
	STOP SLAVE;
- вводим длинную сакральную команду)), используем данные из команды show master status на source:
	CHANGE REPLICATION SOURCE TO SOURCE_HOST='192.168.178.41', SOURCE_USER='repl', SOURCE_PASSWORD='oTUSlave#2020', SOURCE_LOG_FILE='binlog.000003', SOURCE_LOG_POS= 885, GET_SOURCE_PUBLIC_KEY = 1;
- запускаем репликацию
	START REPLICA; 
-проверяем статус подключения и репликации
	show replica status\G
	
5.3 Создание БД, восстановление БД из ранее созданного бэкапа.
- SOURCE. Создаем БД otus_db на source:
	create database otus_db;
- REPLICA. Проверяем что БД otus_db скопировалась
	show databases;
- REPLICA. Убедимся, что БД otus_db пустая
	SELECT * from replica_tabl;
- SOURCE. Восстанавливаем БД из ранее созданного бэкапа.
	sudo mysql -u root -p otus_db < dump2.sql


