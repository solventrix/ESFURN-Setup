# How to execute the ETL for ESFURN data

## Prerequisites
1. Docker is installed and running.
2. docker compose is installed system-wide. Please follow the instructions for installation here: https://docs.docker.com/compose/install/
3. The user has access to the https://harbor.esfurn.org repository containing the ETL image.
4. The ESFURN OMOP CDM database is running in a Docker container named `postgres`:
    * Check this by running `docker ps`. You should see the `postgres` container listed as running and healthy.

## Execution steps
1. Open a terminal window 
2. Create a new directory for the ETL script execution, e.g.:
   * `mkdir etl_run`
   * `cd etl_run`
3. Download the installation script:
    * `curl -L https://raw.githubusercontent.com/solventrix/Esfurn-setup/master/RunETL/runETL.sh --output runETL.sh && chmod +x runETL.sh`
4. Execute the `runETL.sh` script by running `./runETL.sh` from inside the directory where the script is located. It is possible that you will need to use the `sudo` command: `sudo ./runETL.sh`.
5. The script will request for:
    * the path to the folder that contains the input CSV data file
    * the username and password to connect to the OMOP CDM database (a running Docker container named `postgres`)
    * the tag name for the Docker Hub image. Unless instructed otherwise, the default 'current' tag is required.
    * the verbosity level [DEBUG, INFO, WARNING, ERROR]
    * the name of the input datafile
    * the name of the diagnosis code mapping file
    * the name of the drug code mapping file
    * the name of the site collection mapping file
6. The script will run the ETL code and show the output of the code
7. The `etl_<datetime>.log` log file will be available in the `log` folder
8. Review the log file to verify that there is no patient-level information.
