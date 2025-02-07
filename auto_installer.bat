@echo off
setlocal enabledelayedexpansion

:: Check for administrative privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs"
    exit /b
)

:: Check if Python is installed

echo installing python 3.13.2
set "URL=https://www.python.org/ftp/python/3.13.2/python-3.13.2-amd64.exe"
set "INSTALLER=python-3.13.2-amd64.exe"

:: Download the latest installer
echo Downloading %INSTALLER%...
curl -o %INSTALLER% %URL%

:: Run the installer silently
echo Installing Python... 
echo make sure to install python launcher (py launcher)
start /wait %INSTALLER%

:: Cleanup
echo Cleaning up...
del %INSTALLER%

echo Python installation completed.

:: Install Python dependencies
echo Installing Python dependencies...
py -m pip install --upgrade pip
py -m pip install pyautogui pytesseract pillow colorama flask

:: Set Tesseract path (adjust if Tesseract is installed in a different location)
set TESSERACT_PATH="C:\Program Files\Tesseract-OCR\tesseract.exe"


:: Check if Tesseract is installed at the specified path
echo Checking for Tesseract installation at %TESSERACT_PATH%...
if not exist %TESSERACT_PATH% (
    echo Tesseract is not installed at %TESSERACT_PATH%. Downloading and installing Tesseract...
    echo Downloading Tesseract...
    curl -L -o tesseract-installer.exe https://github.com/UB-Mannheim/tesseract/releases/download/v5.4.0.20240606/tesseract-ocr-w64-setup-5.4.0.20240606.exe
    echo Installing Tesseract...
    start /wait tesseract-installer.exe /S
    del tesseract-installer.exe
) else (
    echo Tesseract is already installed at %TESSERACT_PATH%.
)

:: Set the Tesseract path for Python script
echo Setting Tesseract path for Python script...
echo pytesseract.pytesseract.tesseract_cmd = %TESSERACT_PATH% > set_tesseract_path.py

:: Ask user to set Tesseract path in the Python script if necessary
echo Please ensure Tesseract is properly installed. If not, set the path manually in the Python script.
pause

:: Run Python script
echo Running the Python script...
del set_tesseract_path.py
py run.py

pause