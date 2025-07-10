import requests

def test_prediction(home_team: str, away_team: str):
    url = "http://127.0.0.1:8000/predict"
    payload = {
        "home_team": home_team,
        "away_team": away_team
    }

    try:
        response = requests.post(url, json=payload)
        print(f"\nRequesting prediction for {away_team} @ {home_team} ...")
        print("Status Code:", response.status_code)
        print("Response:", response.text)

        if response.status_code == 200:
            print("Good Response")
        else:
            print("Non-200 response, check server logs for details.")
    except Exception as e:
        print("Error during request:", e)

if __name__ == "__main__":
    while True:
        home_team = input("\nEnter home team (or 'q' to quit): ").strip().upper()
        if home_team == 'Q':
            break

        away_team = input("Enter away team: ").strip().upper()
        test_prediction(home_team, away_team)