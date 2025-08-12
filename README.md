(See Installation & Usage for steps on how to use the application.)

# Football Game Margin Predictor

**Predict NFL game margins and identify value bets with data-driven modeling**

## Overview
This project builds a complete end-to-end ML solution to predict point spread (margin) in NFL games. It includes data collection, preprocessing, modeling, evaluation, and deployment via an API—showcasing a production-ready workflow for predictive modeling.

## Project Flow
1. **Data Understanding** (`2_Data_Understanding`)   
   - Collected data from three different sources into a materialized view consisting of 6988 rows and 370 features.
   - Analyzed 25 years of historical football data to uncover trends seen with a games margin.
   - Explore historical game data: correlations, distributions, feature relationships.

3. **Data Preparation** (`3_Data_Preparation`)  
   - Clean data, select relevant features, and scale numeric features.
   - Replaced nulls with averages for the given position if the data was missing and 0 if there was no data found.

4. **Modeling & Evaluation** (`4_5_Modeling_and_Evaluation`)  
   Train and tune Lasso regression using sklearn pipelines.  
   Evaluate with MAE, RMSE, R², and residual analysis using test data.
   Back tested on previous seasons to simulate live predictions.
   

5. **Deployment** (`6_Deployment`)  
   Package the trained pipeline into a FastAPI application that serves predictions to a Next.js frontend.

## Tech Stack
- **Languages & Libraries**: Python, pandas, NumPy, scikit-learn  
- **API**: FastAPI for model serving  
- **Deployment**: Render (Backend), Vercel (Frontend)  
- **Dependencies**: See `requirements.txt`

## Installation & Usage

1. Visit whosgonnawin.vercel.app

2. Sign Up (email used for auth purposes only)

3. Click the verification link sent in the email

4. Select your teams and click Make Prediction.


NOTE: If the app goes inactive, there will be a cold startup period of around 60 seconds, after that predictions should works instantly. 

## 📊 Results & Impact
- **Test Accuracy**: Predictions within ±0.5 points for 75% of sample games.  
- **Model Strength**: On par with bookmaker spreads in predictive consistency.  
- **Explainability**: Coefficients from the Lasso model are used to explain model predictions.
