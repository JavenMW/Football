import joblib
import pandas as pd
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # replace with your frontend URL for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class DataHandler:
    def __init__(self):
        self.data: pd.DataFrame = joblib.load("C:/Code/Git Repositories/Football/Football/3_Data_Preparation/rawdata_clean.pkl")

    def team_query(self, home_team: str, away_team: str) -> pd.DataFrame:

        home_team_stats = self.data[self.data['home_team'] == home_team].sort_values(by=['season', 'week'], ascending=False).iloc[:3]
        home_team_stats = home_team_stats.loc[:, 'season':'hlb3_interception_yards']
        away_team_stats = self.data[self.data['away_team'] == away_team].sort_values(by=['season', 'week'], ascending=False).iloc[:3]
        away_team_stats = away_team_stats.loc[:, 'aqb1':'alb3_interception_yards']

        # home_team_stats = self.data[self.data['home_team'] == home_team].sort_values(by=['season', 'week'], ascending=False).iloc[0]
        # home_team_stats = home_team_stats.loc['season':'hlb3_interception_yards']
        # away_team_stats = self.data[self.data['away_team'] == away_team].sort_values(by=['season', 'week'], ascending=False).iloc[0]
        # away_team_stats = away_team_stats.loc['aqb1':'alb3_interception_yards']

        combined_dict = {}
        away_team_stats_mean = away_team_stats.select_dtypes(include=['float64', 'int64']).mean(axis=0)
        home_team_stats_mean = home_team_stats.select_dtypes(include=['float64', 'int64']).mean(axis=0)
        # Prefix home stats

        for col, val in home_team_stats_mean.items():
            combined_dict[f"{col}"] = val

        # Prefix away stats
        for col, val in away_team_stats_mean.items():
            combined_dict[f"{col}"] = val

        # Create a single-row DataFrame with correct types
        combined_stats = pd.DataFrame([combined_dict])

        print(combined_stats.head())
        return combined_stats

    
    def preprocess_stats(self, game_stats: pd.DataFrame):

        game_stats_processed = game_stats.select_dtypes(include=['float64', 'int64'])

        return game_stats_processed
    

class ModelHandler:
    def __init__(self):
        self.lasso_pipe = joblib.load("C:/Code/Git Repositories/Football/Football/4_5_Modeling_and_Evaluation/lasso_pipeline.pkl")

    def make_prediction(self, home_team: str, away_team: str):
        query = DataHandler()

        game_stats = query.team_query(home_team=home_team, away_team=away_team)
        game_stats_processed = query.preprocess_stats(game_stats)
        prediction = self.lasso_pipe.predict(X=game_stats_processed)
        return prediction[0]


# Define input data model for API
class Teams(BaseModel):
    home_team: str
    away_team: str

model = ModelHandler()

@app.post("/predict")
def predict_margin(teams: Teams):
    print(f"Received request: {teams.home_team} vs {teams.away_team}")
    pred = model.make_prediction(teams.home_team, teams.away_team)

    if pred > 0:
        winner = teams.home_team
    else:
        winner = teams.away_team
    print(f"Prediction: {pred}, Winner: {winner}")
    return {"predicted_margin": pred, "predicted_winner": winner}
