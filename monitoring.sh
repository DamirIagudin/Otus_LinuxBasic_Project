#!/bin/bash

# создаем 2 новые директории с названием prometheus
mkdir -m 755 {/etc/,/var/lib/}prometheus

# копируем готовый файл конфигурации из директории репозитория :
cp -v prometheus.yml /etc/prometheus
# копируем 2 заранее созданных файла конфигурации для systemd из директории репозитория в директорию systemd: /etc/systemd/system командой:
rsync -abvuP node_exporter.service prometheus.service /etc/systemd/system


# создаем директорию в которую будем качать архивы и их потом разархивировать
mkdir $HOME/prometheus

# скачиваем архивы в созданную директорию
cd $HOME/prometheus
curl -LO https://github.com/prometheus/prometheus/releases/download/v2.45.0/prometheus-2.45.0.linux-amd64.tar.gz
curl -LO https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz

#разархивируем оба архива с помощью команды tar:
tar -xvf  node_exporter-1.6.1.linux-amd64.tar.gz
tar -xvf  prometheus-2.45.0.linux-amd64.tar.gz

# добавляем пользователей prometheus и node_exporter:
useradd --no-create-home --shell /usr/bin/false prometheus
useradd --no-create-home --shell /usr/sbin/nologin node_exporter


# копирование в /etc/prometheus
cd $HOME/prometheus/prometheus-2.45.0.linux-amd64
rsync --chown=prometheus:prometheus -arvP consoles console_libraries /etc/prometheus/


# копирование в /usr/local/bin/
rsync --chown=prometheus:prometheus -arvuP prometheus promtool /usr/local/bin/
cd $HOME/prometheus/node_exporter-1.6.1.linux-amd64
rsync --chown=node_exporter:node_exporter -arvuP node_exporter /usr/local/bin/

# gередаем права пользователя prometheus
chown -v -R prometheus: /etc/prometheus
chown -v -R prometheus: /var/lib/prometheus

# для того чтобы systemd увидел, что добавились 2 новых сервиса выполняем команду :
systemctl daemon-reload


# запускаем сервисы и добавляем в автозагрузку
systemctl enable --now prometheus
systemctl enable --now node_exporter
