import nfl_data_py as nfl
from nfl_data_py import import_pbp_data
from datetime import datetime
import psycopg2
from sqlalchemy import create_engine
import pandas as pd

engine = create_engine("postgresql+psycopg2://postgres:NinA321!@localhost:5432/football_db")


def loadYears(start_season: int, end_season: int):
    
    seasons = list(range(start_season, end_season))
    data = nfl.import_pbp_data(seasons)
    return data

def loadAll(start_season=1999, end_season=datetime.now().year):
    
    seasons = list(range(start_season, end_season))
    print(f"Loading seasons {start_season} to {end_season}")
    data = nfl.import_pbp_data(seasons)
    return data

def toCSV(data, filename):

    df = pd.DataFrame(data)
    print(f"Loaded {len(data)} rows of data")
    # Save the data to a CSV file
    df.to_csv(filename, index=False)
    print(f"Saved data to {filename}")


def loadToDB(filename, table_name):
    conn = psycopg2.connect("dbname=football_db user=postgres password=NinA321! host=localhost")
    cur = conn.cursor()

    with open(filename, "r") as f:
        cur.copy_expert(f"COPY {table_name} FROM STDIN WITH CSV HEADER", f)

    conn.commit()
    cur.close()
    conn.close()

def grabOffStats():
    years = range(1999, datetime.now().year)
    
    base_url = "https://github.com/nflverse/nflverse-data/releases/download/player_stats/player_stats_"

    dfs = []
    for year in years:
        url = f"{base_url}{year}.csv.gz"
        print(f"Downloading {url}")
        df = pd.read_csv(url, compression='gzip', low_memory=False)
        df['season'] = year
        dfs.append(df)

    playerStats = pd.concat(dfs, ignore_index=True)

    return playerStats

def grabSeasonDefStats():
    years = range(1999, datetime.now().year)
    
    base_url = "https://github.com/nflverse/nflverse-data/releases/download/player_stats/player_stats_def_season_"

    dfs = []
    for year in years:
        url = f"{base_url}{year}.csv.gz"
        print(f"Downloading {url}")
        df = pd.read_csv(url, compression='gzip', low_memory=False)
        df['season'] = year
        dfs.append(df)

    playerStats = pd.concat(dfs, ignore_index=True)

    return playerStats

def grabKickerStats():
    years = range(1999, 2018)
    
    base_url = "https://github.com/nflverse/nflverse-data/releases/download/player_stats/player_stats_kicking_"
    # alt_url =  "https://github.com/nflverse/nflverse-data/releases/download/player_stats/player_stats_kicking_2022.csv.gz"
    dfs = []
    for year in years:
        url = f"{base_url}{year}.csv.gz"
        print(f"Downloading {url}")
        df = pd.read_csv(url, compression='gzip', low_memory=False)
        df['season'] = year
        dfs.append(df)

    playerStats = pd.concat(dfs, ignore_index=True)

    return playerStats

def grabRosters():
    years = range(1999, 2024)
    
    base_url = "https://github.com/nflverse/nflverse-data/releases/download/rosters/roster_"
    # alt_url =  "https://github.com/nflverse/nflverse-data/releases/download/player_stats/player_stats_kicking_2022.csv.gz"
    
    dfs = []
    for year in years:
        url = f"{base_url}{year}.csv"
        print(f"Downloading {url}")
        df = pd.read_csv(url, low_memory=False)
        df['season'] = year
        dfs.append(df)

    playerStats = pd.concat(dfs, ignore_index=True)

    return playerStats

def grabDepth():
    years = range(2001, 2024)
    
    base_url = "https://github.com/nflverse/nflverse-data/releases/download/depth_charts/depth_charts_"
    # alt_url =  "https://github.com/nflverse/nflverse-data/releases/download/depth_charts/depth_charts_2001.csv"
    
    dfs = []
    for year in years:
        url = f"{base_url}{year}.csv"
        print(f"Downloading {url}")
        df = pd.read_csv(url, low_memory=False)
        df['season'] = year
        dfs.append(df)

    playerStats = pd.concat(dfs, ignore_index=True)

    return playerStats

def grabWeeklyDef():
    years = range(2001, 2024)
    
    base_url = "https://github.com/nflverse/nflverse-data/releases/download/player_stats/player_stats_def_"
    # alt_url =  "https://github.com/nflverse/nflverse-data/releases/download/depth_charts/depth_charts_2001.csv"
    
    dfs = []
    for year in years:
        url = f"{base_url}{year}.csv"
        print(f"Downloading {url}")
        df = pd.read_csv(url, low_memory=False)
        df['season'] = year
        dfs.append(df)

    playerStats = pd.concat(dfs, ignore_index=True)

    return playerStats

def createTable(data, table_name):
    data.head(0).to_sql(table_name, engine, if_exists="replace", index=False)

def main():
    filename = "resources\RawDefWeekly.csv"
    table_name = "rawdefweekly" 
    data = grabWeeklyDef()
    toCSV(data, filename)
    print("Data saved to CSV")
    createTable(data, table_name)
    loadToDB(filename, table_name)
    print("Data loaded to DB")
    # Save the data to a CSV file
    print("End of Program")

if __name__ == "__main__":
    main()