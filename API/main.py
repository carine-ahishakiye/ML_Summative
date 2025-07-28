from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

app = FastAPI()

# ✅ CORS setup for allowing requests from frontend (adjust origin if needed)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # You can replace "*" with your frontend URL for better security
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ✅ Request schema
class SalaryRequest(BaseModel):
    employment_type: str
    experience_level: str

# ✅ Response schema (optional but clean)
class SalaryResponse(BaseModel):
    predicted_salary: int

@app.get("/")
def read_root():
    return {"message": "FastAPI backend is running"}

@app.post("/predict", response_model=SalaryResponse)
def predict_salary(data: SalaryRequest):
    # Dummy logic — replace with ML model later if needed
    base_salary = 50000
    if data.experience_level.upper() == "EX":
        base_salary = 120000
    elif data.experience_level.upper() == "SE":
        base_salary = 90000
    elif data.experience_level.upper() == "MI":
        base_salary = 70000
    elif data.experience_level.upper() == "EN":
        base_salary = 50000

    return {"predicted_salary": base_salary}
