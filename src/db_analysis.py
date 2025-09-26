import os
from utils import DuckDBOperator


print(os.getcwd())

db_operator = DuckDBOperator(project_root_dir=os.getcwd(), db_name="inspection_database.db")


def show_tables():
    query_str = """SELECT database_name, schema_name, table_name FROM duckdb_tables"""
    df = db_operator.query(query_str)
    print(df)

def query_top_ten_rows():
    query_str = """
                    SELECT *
                    FROM inspection_database.staging.chicago_food_establishments_stg
                    LIMIT 10
                """
    df = db_operator.query(query_str)
    print(df.head())

if __name__ == "__main__":
    query_top_ten_rows()
