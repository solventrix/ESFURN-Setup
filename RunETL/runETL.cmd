@echo off

curl -L https://raw.githubusercontent.com/solventrix/ESFURN-setup/master/RunETL/docker-compose.yml --output docker-compose.yml

set "data_folder=./data"
set /p "data_folder=Input Data folder [%data_folder%]: "

set "db_username=feder8_admin"
set /p "db_username=DB username [%db_username%]: "

set "db_password="
set /p "db_password=DB password: "

set "verbosity_level=INFO"
set /p "verbosity_level=Output verbosity level [%verbosity_level%]: "

set "image_tag=current"
set /p "image_tag=Docker Hub image tag [%image_tag%]: "

:extraction_date
set "date_last_export="
set /p "date_last_export=Date of last export yyyy-mm-dd: "
IF [%date_last_export%]==[] (
	echo Please enter the date of the source data export!
	Timeout /T 2 /NoBreak>nul
	goto extraction_date
) ELSE (
	goto next_step
)

:next_step

set "input_filename=ESFURN_data_collection.xlsx"
set /p "input_filename=Input filename [%input_filename%]: "

set "diagnosis_filename=diagnosis_codes.csv"
set /p "diagnosis_filename=Diagnosis lookup filename [%diagnosis_filename%]: "

set "drug_filename=drug_codes.csv"
set /p "drug_filename=Drug lookup filename [%drug_filename%]: "

set "tissue_filename=tissue_codes.csv"
set /p "tissue_filename=Tissue lookup filename [%tissue_filename%]: "

set "other_therapies_filename=muc_therapy_other_therapies.csv"
set /p "other_therapies_filename=Other therapies lookup filename [%other_therapies_filename%]: "

set "esfurn_site=ESFURN"
set /p "esfurn_site=Name of your site or data set [%esfurn_site%]: "

powershell -Command "(Get-Content docker-compose.yml) -creplace 'data_folder', '%data_folder%' | Set-Content docker-compose.yml"
powershell -Command "(Get-Content docker-compose.yml) -creplace 'db_username', '%db_username%' | Set-Content docker-compose.yml"
powershell -Command "(Get-Content docker-compose.yml) -creplace 'db_password', '%db_password%' | Set-Content docker-compose.yml"
powershell -Command "(Get-Content docker-compose.yml) -creplace 'verbosity_level', '%verbosity_level%' | Set-Content docker-compose.yml"
powershell -Command "(Get-Content docker-compose.yml) -creplace 'image_tag', '%image_tag%' | Set-Content docker-compose.yml"
powershell -Command "(Get-Content docker-compose.yml) -creplace 'date_last_export', '%date_last_export%' | Set-Content docker-compose.yml"
powershell -Command "(Get-Content docker-compose.yml) -creplace 'input_filename', '%input_filename%' | Set-Content docker-compose.yml"
powershell -Command "(Get-Content docker-compose.yml) -creplace 'diagnosis_filename', '%diagnosis_filename%' | Set-Content docker-compose.yml"
powershell -Command "(Get-Content docker-compose.yml) -creplace 'drug_filename', '%drug_filename%' | Set-Content docker-compose.yml"
powershell -Command "(Get-Content docker-compose.yml) -creplace 'tissue_filename', '%tissue_filename%' | Set-Content docker-compose.yml"
powershell -Command "(Get-Content docker-compose.yml) -creplace 'other_therapies_filename', '%other_therapies_filename%' | Set-Content docker-compose.yml"
powershell -Command "(Get-Content docker-compose.yml) -creplace 'esfurn_site', '%esfurn_site%' | Set-Content docker-compose.yml"

docker login harbor.esfurn.org
docker compose pull
docker compose run --rm --name etl etl
