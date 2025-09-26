FROM python:3.11-slim

WORKDIR /dbt-project

RUN apt-get update && apt-get install -y curl unzip && rm -rf /var/lib/apt/lists/*

RUN curl https://install.duckdb.org | sh

ENV PATH="/root/.duckdb/cli/latest:$PATH"



COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt


COPY . .

ENV DBT_PROFILES_DIR=/dbt-project

CMD ["bash"]

