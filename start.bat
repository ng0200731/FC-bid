@echo off
title Artwork Downloader - Starting...

echo.
echo ========================================
echo   Artwork Downloader
echo ========================================
echo.
echo Starting the web application...
echo.

REM Change to the script directory
echo Changing to directory: %~dp0
cd /d "%~dp0"
echo Current directory: %CD%
echo.

REM Check if smart_app.py exists
if not exist "smart_app.py" (
    echo Error: smart_app.py not found in current directory
    echo Please make sure you are running this from the correct folder
    echo Expected file: %CD%\smart_app.py
    pause
    exit /b 1
)
echo Found smart_app.py

REM Check if Python is available
echo Checking Python installation...
py --version
if errorlevel 1 (
    echo Error: Python is not installed or not in PATH
    echo Please install Python from https://python.org
    pause
    exit /b 1
)
echo Python OK

REM Check if required packages are installed
echo Checking dependencies...
py -c "import flask; print('Flask OK')" 2>nul
if errorlevel 1 (
    echo Installing Flask with fast mirror...
    py -m pip install -i https://mirrors.aliyun.com/pypi/simple/ flask --trusted-host mirrors.aliyun.com
    if errorlevel 1 (
        echo Failed to install Flask
        pause
        exit /b 1
    )
)

py -c "import requests; print('Requests OK')" 2>nul
if errorlevel 1 (
    echo Installing Requests with fast mirror...
    py -m pip install -i https://mirrors.aliyun.com/pypi/simple/ requests --trusted-host mirrors.aliyun.com
)

py -c "import bs4; print('BeautifulSoup OK')" 2>nul
if errorlevel 1 (
    echo Installing BeautifulSoup with fast mirror...
    py -m pip install -i https://mirrors.aliyun.com/pypi/simple/ beautifulsoup4 --trusted-host mirrors.aliyun.com
)

py -c "import selenium; print('Selenium OK')" 2>nul
if errorlevel 1 (
    echo Installing Selenium with fast mirror...
    py -m pip install -i https://mirrors.aliyun.com/pypi/simple/ selenium --trusted-host mirrors.aliyun.com
    if errorlevel 1 (
        echo Failed to install Selenium
        pause
        exit /b 1
    )
)

py -c "import webdriver_manager; print('WebDriver Manager OK')" 2>nul
if errorlevel 1 (
    echo Installing WebDriver Manager with fast mirror...
    py -m pip install -i https://mirrors.aliyun.com/pypi/simple/ webdriver-manager --trusted-host mirrors.aliyun.com
)

echo All dependencies OK
echo.

REM Kill any existing Python processes to ensure clean start
echo Stopping any existing Python processes...
taskkill /f /im python.exe >nul 2>&1
taskkill /f /im py.exe >nul 2>&1
echo Previous Python processes stopped (if any were running)
echo.

echo Starting Flask web server...
echo Chrome will open automatically in 3 seconds...
echo Press Ctrl+C to stop the server
echo.

REM Start the Flask app in background
start /b py smart_app.py

REM Wait for Flask to start
echo Waiting for server to start...
timeout /t 3 /nobreak >nul

REM Open Chrome browser
echo Opening Chrome browser...
start chrome "http://localhost:5002" >nul 2>&1
if errorlevel 1 (
    echo Chrome not found, opening default browser...
    start "" "http://localhost:5002" >nul 2>&1
)

echo.
echo Web application is running!
echo Chrome should now be open with the application.
echo Press any key to stop the server and close this window...
pause >nul

REM Kill the Python process
taskkill /f /im python.exe >nul 2>&1

REM If we get here, the app has stopped
echo.
echo Application stopped.
echo Press any key to close this window...
pause >nul
