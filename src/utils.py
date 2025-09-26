import logging
from contextlib import contextmanager
from pathlib import Path
from typing import Optional

import duckdb
import pandas as pd


class QueryError(Exception):
    def __init__(self, message):
        super().__init__(message)
        self.message = message



class DuckDBOperator:
    def __init__(self, project_root_dir: Path, db_name: str = "database.db"):
        self.project_root_dir = Path(project_root_dir)
        self.db_name = db_name
        self.set_db_path()
        self.logger = logging.getLogger(self.__class__.__name__)

    def set_db_path(self) -> None:
        self.db_path = self.project_root_dir.joinpath("data", self.db_name)

    @contextmanager
    def _get_connection(self):
        """Context manager for handling database connections."""
        conn = None
        try:
            print(f"setting connection with db_path: {self.db_path}")
            conn = duckdb.connect(self.db_path)
            yield conn
        finally:
            if conn:
                conn.close()

    def _execute_query(
        self, sql: str, conn: duckdb.DuckDBPyConnection
    ) -> pd.DataFrame:
        try:
            print(f"running query: {sql}")
            result = conn.execute(sql)
            return result.df()
        except Exception as e:
            self.logger.error(f"Failed to execute query: {sql}")
            raise QueryError(f"Query execution failed: {str(e)}")

    def query(
        self, sql: str, conn: Optional[duckdb.DuckDBPyConnection] = None
    ) -> pd.DataFrame:
        if conn:
            return self._execute_query(sql, conn)
        else:
            with self._get_connection() as conn:
                return self._execute_query(sql, conn)
