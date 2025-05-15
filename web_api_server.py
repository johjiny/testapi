from fastapi import FastAPI
import requests
from bs4 import BeautifulSoup

app = FastAPI()

@app.get("/crawl")
def crawl(url: str):
    res = requests.get(url)
    soup = BeautifulSoup(res.text, "html.parser")
    titles = [h.text.strip() for h in soup.select("h1, h2") if h.text.strip()]
    return {"url": url, "headlines": titles[:5]}
