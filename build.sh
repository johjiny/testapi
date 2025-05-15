#!/usr/bin/env bash

# Chrome 설치
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install -y ./google-chrome-stable_current_amd64.deb

# ChromeDriver 버전 맞추기
CHROME_VERSION=$(google-chrome --version | awk '{ print $3 }' | cut -d '.' -f 1)
wget -N https://chromedriver.storage.googleapis.com/$(curl -s https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION)/chromedriver_linux64.zip
unzip chromedriver_linux64.zip
mv chromedriver /usr/local/bin/chromedriver
chmod +x /usr/local/bin/chromedriver
