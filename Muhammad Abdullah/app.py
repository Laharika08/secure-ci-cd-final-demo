from fastapi import FastAPI
from pydantic import BaseModel
from transformers import pipeline

# Initialize FastAPI app
app = FastAPI()

# Load GPT-2 text generation model
generator = pipeline("text-generation", model="gpt2")

# Define request model
class GenerateRequest(BaseModel):
    prompt: str
    max_length: int = 50  # Default max length

@app.post("/generate/")
async def generate_text(request: GenerateRequest):
    generated_text = generator(
        request.prompt, 
        max_length=request.max_length,  # User-defined or default
        num_return_sequences=1, 
        temperature=0.7,  # Reduces hallucinations
        top_p=0.9         # Uses nucleus sampling for relevance
    )
    return {"response": generated_text[0]["generated_text"]}

@app.get("/")
def home():
    return {"message": "API is running!"}
