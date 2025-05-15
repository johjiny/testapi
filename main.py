from fastapi import FastAPI
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException, NoSuchElementException
import os

app = FastAPI()

CHROMEDRIVER_PATH = "/usr/local/bin/chromedriver"  # Render 환경에 맞게 수정 필요

@app.get("/naver/top10")
def get_top10_news():
    options = Options()
    options.add_argument('--headless')
    options.add_argument('--disable-gpu')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')
    options.add_argument("user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36")

    service = Service(executable_path=CHROMEDRIVER_PATH)
    driver = webdriver.Chrome(service=service, options=options)

    try:
        url = "https://media.naver.com/press/009/ranking?type=popular"
        driver.get(url)

        articles = WebDriverWait(driver, 20).until(
            EC.presence_of_all_elements_located((By.CSS_SELECTOR, 'div.press_ranking_box ul.press_ranking_list > li'))
        )

        top10 = []
        for idx, article in enumerate(articles[:10], start=1):
            try:
                title = article.find_element(By.CSS_SELECTOR, 'strong.list_title').text.strip()
                link = article.find_element(By.TAG_NAME, 'a').get_attribute('href')
                top10.append({"rank": f"{idx}위", "title": title, "link": link})
            except NoSuchElementException:
                continue

        return {"top10": top10}

    except TimeoutException:
        return {"error": "크롤링 타임아웃 발생"}
    finally:
        driver.quit()
