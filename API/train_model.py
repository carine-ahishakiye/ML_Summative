# train_model.py

import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import LabelEncoder
import joblib

# Load dataset
df = pd.read_csv("ds_salaries.csv")

# Encode categorical columns
le_employment = LabelEncoder()
le_experience = LabelEncoder()

df['employment_type_encoded'] = le_employment.fit_transform(df['employment_type'])
df['experience_level_encoded'] = le_experience.fit_transform(df['experience_level'])

# Define features and target
X = df[['employment_type_encoded', 'experience_level_encoded']]
y = df['salary_in_usd']

# Train the model
model = LinearRegression()
model.fit(X, y)

# Save model and encoders
joblib.dump(model, "salary_model.joblib")
joblib.dump(le_employment, "employment_encoder.joblib")
joblib.dump(le_experience, "experience_encoder.joblib")

print("✅ Model and encoders saved.")
