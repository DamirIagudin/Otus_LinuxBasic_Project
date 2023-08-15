# Otus_LinuxBasic_Project
ПРОЕКТНАЯ РАБОТА ПО КУРСУ ADMINISTRATOR LINUX.BASIC.

Проектная работа выполняется с использованием двух виртуальных машин, созданных в VirtualBox при помощи Vagrant. Vagrantfile с настройками виртуальных машин находится в текущем репозитории.

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
- проверка работы вебсервер из браузера на адрес 192.168.178.11

4. Настройка системы мониторинга
- установка и конфигурация Prometheus и node_exporter
sudo bash monitoring.sh
- установка и конфигурация Grafana
sudo bash grafana.sh 
- проверка открытых сокетов
sudo ss -ntlp	
- создание в браузере дашборда для мониторинга;
	настройка data_sources:
	http://192.168.178.11:9090
	импорт дашборда 1860
	
	
5. Установка, конфигурация, репликация MySQL. Восстановление из ранее созданного бэкапа.

5.1 Установка, конфигурация MySQL на Source (linux-spec1).
- установка и конфигурация MySQL
sudo bash mysql_source.sh  
- создаем пользователя для репликации
CREATE USER repl@'%' IDENTIFIED WITH 'caching_sha2_password' BY 'oTUSlave#2020'; 
- предоставляем новому пользователю права
GRANT REPLICATION SLAVE ON *.* TO repl@'%';	
- для настройки репликации на linux-spec2 смотрим текущий binlog MASTER_LOG_FILE='binlog.000008'
show master status;
	
5.2 Установка, конфигурация MySQL на Replica (linux-spec2).
- установка и конфигурация MySQL
sudo bash mysql_replica.sh 
- на всякий случай делаем стоп репликации
STOP SLAVE;
- вводим длинную сакральную команду)), используем данные из команды show master status на source:
CHANGE REPLICATION SOURCE TO SOURCE_HOST='192.168.178.11', SOURCE_USER='repl', SOURCE_PASSWORD='oTUSlave#2020', SOURCE_LOG_FILE='binlog.000003', SOURCE_LOG_POS= 885, GET_SOURCE_PUBLIC_KEY = 1;
- запускаем репликацию
START REPLICA; 
- проверяем статус подключения и репликации
show replica status\G
	
5.3 Создание БД, восстановление БД из ранее созданного бэкапа.
- SOURCE. Создаем БД otus_db на source:
create database otus_db;
- REPLICA. Проверяем что БД otus_db скопировалась
show databases;
- REPLICA. Убедимся, что БД otus_db пустая
show tables;
SELECT * from replica_tabl;
- SOURCE. Восстанавливаем БД из ранее созданного бэкапа.
sudo mysql -u root -p otus_db < dump2.sql
	
5.4 Настройка бэкапа БД otus_db на REPLICA (linux-spec2).
- открываем Crontab
crontab -e
- добавляем в конце строку, в которой указывается, что делаем бэкап каждую минуту (для демонстрации), используем команду mysqldump с записью имени 	binlog и позиции 

* * * * * sudo mysqldump -uroot -p --source-data=2 otus_db replica_tabl > /home/vagrant/Otus_LinuxBasic_Project/dump_cron.sql


