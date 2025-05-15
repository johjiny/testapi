FROM python:3.11

# 필수 시스템 패키지 설치
RUN apt-get update
RUN apt-get install -y wget unzip gnupg curl

# Chrome 설치
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt-get install -y ./google-chrome-stable_current_amd64.deb

# ChromeDriver 버전 확인 및 다운로드
RUN CHROME_VERSION=$(google-chrome --version | awk '{ print $3 }' | cut -d '.' -f 1) && \
    CHROMEDRIVER_VERSION=$(curl -s https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION) && \
    wget -N https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip && \
    mv chromedriver /usr/local/bin/chromedriver && \
    chmod +x /usr/local/bin/chromedriver

# 작업 디렉토리 설정
WORKDIR /app

# 소스 복사
COPY . .

# Python 의존성 설치
RUN pip install --no-cache-dir -r requirements.txt

# 애플리케이션 실행
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "10000"]
