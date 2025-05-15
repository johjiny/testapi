FROM python:3.11

# 필수 패키지 및 Chrome 설치
RUN apt-get update && apt-get install -y wget unzip gnupg curl \
    && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get install -y ./google-chrome-stable_current_amd64.deb \
    && CHROME_VERSION=$(google-chrome --version | awk '{ print $3 }' | cut -d '.' -f 1) \
    && CHROMEDRIVER_VERSION=$(curl -s https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION) \
    && wget -N https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip \
    && unzip chromedriver_linux64.zip \
    && mv chromedriver /usr/local/bin/chromedriver \
    && chmod +x /usr/local/bin/chromedriver

# 앱 폴더로 이동
WORKDIR /app

# 소스 코드 복사
COPY . .

# Python 의존성 설치
RUN pip install --no-cache-dir -r requirements.txt

# 앱 실행
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "10000"]
