import psycopg2
import pandas as pd
from sqlalchemy import create_engine

def cleanPS():
    conn = psycopg2.connect("dbname=football_db user=postgres password=NinA321! host=localhost")

    data = pd.read_sql("SELECT * FROM rawplayerstats", conn)
    cur = conn.cursor()



def main():
    print("Loading data...")


if __name__ == "__main__":
    main()