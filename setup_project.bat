@echo off
echo ========================================
echo    Crafts Portal - Project Setup
echo ========================================
echo.

echo Checking Flutter installation...
flutter --version
if %errorlevel% neq 0 (
    echo ERROR: Flutter is not installed or not in PATH
    echo Please install Flutter from https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
)

echo.
echo Installing dependencies...
flutter pub get

echo.
echo Checking for Firebase configuration...
if not exist "android\app\google-services.json" (
    echo WARNING: google-services.json not found
    echo Please follow the firebase_setup_guide.md to configure Firebase
    echo.
)

echo.
echo Project setup completed!
echo.
echo Next steps:
echo 1. Follow firebase_setup_guide.md to configure Firebase
echo 2. Run 'flutter run' to start the app
echo 3. Run 'build_apk.bat' to build the APK
echo.
pause 