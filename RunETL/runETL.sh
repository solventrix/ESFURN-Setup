if [ $(docker ps --filter "name=etl" | grep -w 'etl' | wc -l) = 1 ]; then
  docker stop -t 1 etl && docker rm etl;
fi

curl -L https://raw.githubusercontent.com/solventrix/Esfurn-setup/master/RunETL/docker-compose.yml --output docker-compose.yml

read -p "Input Data folder [./data]: " data_folder
data_folder=${data_folder:-./data}
read -p "DB username [esfurn_admin]: " db_username
db_username=${db_username:-esfurn_admin}
read -p "DB password [esfurn_admin]: " db_password
db_password=${db_password:-esfurn_admin}
read -p "Output verbosity level [INFO]: " verbosity_level
verbosity_level=${verbosity_level:-INFO}
read -p "Docker Hub image tag [current]: " image_tag
image_tag=${image_tag:-current}
read -p "Date of last export yyyy-mm-dd [\"2021-06-01\"]: " date_last_export
date_last_export=${date_last_export:-\"2021-06-01\"}

read -p "Input filename [ESFURN_data_collection.xlsx]: " input_filename
input_filename=${input_filename:-ESFURN_data_collection.xlsx}
read -p "Diagnosis lookup filename [diagnosis_codes.csv]: " diagnosis_filename
diagnosis_filename=${diagnosis_filename:-diagnosis_codes.csv}
read -p "Drug lookup filename [drug_codes.csv]: " drug_filename
drug_filename=${drug_filename:-drug_codes.csv}
read -p "Tissue lookup filename [tissue_codes.csv]: " tissue_filename
tissue_filename=${tissue_filename:-tissue_codes.csv}

sed -i -e "s@data_folder@$data_folder@g" docker-compose.yml
sed -i -e "s/db_username/$db_username/g" docker-compose.yml
sed -i -e "s/db_password/$db_password/g" docker-compose.yml
sed -i -e "s/verbosity_level/$verbosity_level/g" docker-compose.yml
sed -i -e "s/image_tag/$image_tag/g" docker-compose.yml
sed -i -e "s/date_last_export/$date_last_export/g" docker-compose.yml
sed -i -e "s/input_filename/$input_filename/g" docker-compose.yml
sed -i -e "s/diagnosis_filename/$diagnosis_filename/g" docker-compose.yml
sed -i -e "s/drug_filename/$drug_filename/g" docker-compose.yml
sed -i -e "s/tissue_filename/$tissue_filename/g" docker-compose.yml

docker login harbor.esfurn.org
docker-compose pull
docker-compose run --rm --name etl etl
