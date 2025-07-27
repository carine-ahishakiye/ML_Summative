# main.py

from fastapi import FastAPI
from pydantic import BaseModel
import joblib
import numpy as np

# Load model and encoders
model = joblib.load("salary_model.joblib")
le_employment = joblib.load("employment_encoder.joblib")
le_experience = joblib.load("experience_encoder.joblib")

app = FastAPI()

# Request body structure
class SalaryRequest(BaseModel):
    employment_type: str
    experience_level: str

# Root endpoint
@app.get("/")
def read_root():
    return {"message": "Salary Prediction API is live!"}

# Prediction endpoint
@app.post("/predict")
def predict_salary(data: SalaryRequest):
    try:
        emp_encoded = le_employment.transform([data.employment_type])
        exp_encoded = le_experience.transform([data.experience_level])
        features = np.array([[emp_encoded[0], exp_encoded[0]]])
        prediction = model.predict(features)
        return {"predicted_salary_usd": round(prediction[0], 2)}
    except Exception as e:
        return {"error": str(e)}
