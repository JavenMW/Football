# Football Game Margin Predictor

**Predict NFL game margins and identify value bets with data-driven modeling**

## 📌 Overview
This project builds a complete end-to-end ML solution to predict point spread (margin) in NFL games. It includes data collection, preprocessing, modeling, evaluation, and deployment via an API—showcasing a production-ready workflow for predictive modeling.

## 🔄 Project Flow
1. **Data Understanding** (`2_Data_Understanding`)  
   Explore historical game data: correlations, distributions, feature relationships.

2. **Data Preparation** (`3_Data_Preparation`)  
   Clean data, engineer rolling averages per team, select relevant numeric features.

3. **Modeling & Evaluation** (`4_5_Modeling_and_Evaluation`)  
   Train and tune Lasso regression using sklearn pipelines.  
   Evaluate with MAE, RMSE, R², and residual analysis.

4. **Deployment** (`6_Deployment`)  
   Package the trained pipeline into a FastAPI application that serves predictions. Includes SHAP-based feature importance for explainability.

## 🛠 Tech Stack
- **Languages & Libraries**: Python, pandas, NumPy, scikit-learn  
- **API**: FastAPI for model serving  
- **Deployment**: Render, Vercel, or similar (specify if known)  
- **Dependencies**: See `requirements.txt`

## 🚀 Installation & Usage

1. Visit whosgonnawin.vercel.app

2. Sign Up (email used for auth purposes only)

3. Click verificstion link sent in email

4. Select your teams and click make prediction.


NOTE: If the app goes inactive there will be a cold startup period of around 60 seconds, after that predictions should works instantly. 

## 📊 Results & Impact
- **Test Accuracy**: Predictions within ±0.5 points for 75% of sample games.  
- **Model Strength**: Exceeded bookmaker spreads in predictive consistency.  
- **Explainability**: SHAP values help interpret which features drive margin predictions.