@echo off
echo Building Crafts Portal APK...
echo.

echo Cleaning previous builds...
flutter clean

echo Getting dependencies...
flutter pub get

echo Building APK...
flutter build apk --release

echo.
echo APK build completed!
echo APK location: build\app\outputs\flutter-apk\app-release.apk
echo.
pause 