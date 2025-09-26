# Local Testing and Operation


## Local Environment (Docker)
Use the following command to launch the Docker Container to materialize the DBT models with DBT commands:

`make up`

This command will:
1. build a docker container.
2. install dependencies defined in `requirements.txt`
3. install the DuckDB command line tool
4. mount the container's file directory to the host system
5. open a bash shell within the container for local testing and development


## Materializing and Testing DBT Models 
First, prep the environment with `dbt deps`

To run dbt models, use the `dbt run` command

The `--select` operator is also available to run specific models, tags or folders.

For instance, use:
* `dbt run --select <model-name>` to materialize a single model
* `dbt run --select <folder-path>` to materialize all models in a folder-path
* `dbt run --select tag:<tag-name>` to run models labeled with a tag. Valid tags are: `staging`, `intermediate`, `nyc`, `chicago`, `sf`, `bronze`, `silver`, `gold`


