#!/usr/bin/env bash
set -e

if [ $(docker ps --filter "name=etl" | grep -w 'etl' | wc -l) = 1 ]; then
  docker stop -t 1 etl && docker rm etl;
fi

echo "Download compose file"
curl -fsSL https://raw.githubusercontent.com/solventrix/ESFURN-Setup/refs/heads/master/RunETL/docker-compose.yml --output docker-compose.yml

read -p "Input Data folder [./data]: " data_folder
data_folder=${data_folder:-./data}
read -p "Input filename [ESFURN_data_collection.xlsx]: " input_filename
input_filename=${input_filename:-ESFURN_data_collection.xlsx}
read -p "Date of last export yyyy-mm-dd [\"2024-05-01\"]: " date_last_export
date_last_export=${date_last_export:-\"2024-05-01\"}
read -p "DB password [feder8_admin]: " db_password
db_password=${db_password:-feder8_admin}

sed -i -e "s@data_folder@$data_folder@g" docker-compose.yml
sed -i -e "s/date_last_export/$date_last_export/g" docker-compose.yml
sed -i -e "s/input_filename/$input_filename/g" docker-compose.yml
sed -i -e "s/db_password/$db_password/g" docker-compose.yml

echo "Run ETL"
docker login harbor.esfurn.org
docker compose pull
docker compose run --rm --name etl etl