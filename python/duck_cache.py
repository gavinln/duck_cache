"""
cache dataframes using duckdb
"""
import pathlib
import logging

import pandas as pd
import duckdb


SCRIPT_DIR = pathlib.Path(__file__).parent.resolve()
log = logging.getLogger(__file__)


def temp(i: int):
    print("value {}".format(i))


def get_db_conn():
    "get duckdb connection"
    conn = duckdb.connect(database=":memory:", read_only=False)
    return conn


def save_df(conn, df):
    "save dataframe to a duckdb"
    conn.register("temp_df", df)
    conn.execute("create table table_df as select * from temp_df")
    conn.unregister("temp_df")


def show_tables(conn):
    return conn.execute("PRAGMA show_tables").fetchall()


def main() -> None:
    conn = get_db_conn()
    df1 = pd.DataFrame([[1, 2], [4, 4]], columns=[list("ab")])
    save_df(conn, df1)
    print(show_tables(conn))


if __name__ == "__main__":
    logging.basicConfig(level=logging.WARN)
    main()
