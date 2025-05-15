FROM python:3.11

# 시스템 패키지 설치
RUN apt-get update
RUN apt-get install -y wget unzip gnupg curl

# Google Chrome 설치
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt-get install -y ./google-chrome-stable_current_amd64.deb

# ChromeDriver 버전 고정 설치
# 현재 Chrome 버전: 136.0.7103.113 -> 맞는 드라이버: 136.0.7103.113
RUN wget -N https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/136.0.7103.113/linux64/chromedriver-linux64.zip && \
    unzip chromedriver-linux64.zip && \
    mv chromedriver-linux64/chromedriver /usr/local/bin/chromedriver && \
    chmod +x /usr/local/bin/chromedriver

# 작업 디렉토리 설정
WORKDIR /app

# 소스 복사
COPY . .

# Python 패키지 설치
RUN pip install --no-cache-dir -r requirements.txt

# FastAPI 앱 실행
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "10000"]
