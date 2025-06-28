@echo off
echo ========================================
echo    Upload to GitHub for APK Build
echo ========================================
echo.

echo This script will help you upload your project to GitHub
echo so you can get your APK file automatically built.
echo.

echo Step 1: Create a GitHub repository
echo - Go to https://github.com/new
echo - Name it: crafts-portal
echo - Make it Public
echo - Don't initialize with README
echo.

echo Step 2: Install Git (if not already installed)
echo - Download from: https://git-scm.com/download/win
echo - Install with default settings
echo.

echo Step 3: Initialize Git repository
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Git is not installed
    echo Please install Git first
    pause
    exit /b 1
)

echo Initializing Git repository...
git init
git add .
git commit -m "Initial commit: Crafts Portal Flutter app"

echo.
echo Step 4: Connect to GitHub
echo - Copy the repository URL from GitHub
echo - It should look like: https://github.com/yourusername/crafts-portal.git
echo.

set /p repo_url="Enter your GitHub repository URL: "

echo.
echo Connecting to GitHub...
git remote add origin %repo_url%
git branch -M main
git push -u origin main

echo.
echo Step 5: Get your APK
echo - Go to your GitHub repository
echo - Click on "Actions" tab
echo - Wait for the build to complete
echo - Download the APK from the workflow run
echo.

echo Repository URL: %repo_url%
echo Actions URL: %repo_url%/actions
echo.

echo Success! Your project is now on GitHub.
echo The APK will be built automatically.
echo.

pause 