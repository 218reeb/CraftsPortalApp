# APK Build Instructions for Crafts Portal

## Prerequisites

Before building the APK, ensure you have:

1. **Flutter SDK** installed (version 3.0.0 or higher)
2. **Android Studio** with Android SDK
3. **Java Development Kit (JDK)** version 8 or higher
4. **Firebase Configuration** completed (optional for basic build)

## Installation Steps

### 1. Install Flutter

1. **Download Flutter SDK**:
   - Visit: https://flutter.dev/docs/get-started/install/windows
   - Download the latest Flutter SDK zip file
   - Extract to `C:\flutter` (or your preferred location)

2. **Add Flutter to PATH**:
   - Open System Properties → Advanced → Environment Variables
   - Edit the PATH variable
   - Add `C:\flutter\bin` to the PATH
   - Click OK and restart your command prompt

3. **Verify Installation**:
   ```bash
   flutter --version
   flutter doctor
   ```

### 2. Install Android Studio

1. **Download Android Studio**:
   - Visit: https://developer.android.com/studio
   - Download and install Android Studio

2. **Install Android SDK**:
   - Open Android Studio
   - Go to Tools → SDK Manager
   - Install Android SDK (API level 21 or higher)
   - Install Android SDK Build-Tools
   - Install Android SDK Platform-Tools

3. **Set ANDROID_HOME**:
   - Add `C:\Users\[YourUsername]\AppData\Local\Android\Sdk` to PATH
   - Set ANDROID_HOME environment variable

### 3. Accept Android Licenses

```bash
flutter doctor --android-licenses
```

Accept all licenses when prompted.

## Building the APK

### Method 1: Using the Build Script (Recommended)

1. **Open Command Prompt** in the project directory:
   ```bash
   cd C:\Users\T218r\Desktop\craftsportal
   ```

2. **Run the build script**:
   ```bash
   build_apk.bat
   ```

### Method 2: Manual Build

1. **Clean the project**:
   ```bash
   flutter clean
   ```

2. **Get dependencies**:
   ```bash
   flutter pub get
   ```

3. **Build the APK**:
   ```bash
   flutter build apk --release
   ```

## APK Location

After successful build, the APK will be located at:
```
build\app\outputs\flutter-apk\app-release.apk
```

## Troubleshooting

### Common Issues

1. **Flutter not found**:
   - Ensure Flutter is added to PATH
   - Restart command prompt after adding to PATH

2. **Android SDK not found**:
   - Install Android Studio and SDK
   - Set ANDROID_HOME environment variable

3. **Build fails**:
   - Run `flutter doctor` to check setup
   - Ensure all dependencies are installed
   - Check for any error messages

4. **Firebase configuration missing**:
   - The app will work without Firebase for basic testing
   - Follow `firebase_setup_guide.md` for full functionality

### Build Commands Reference

```bash
# Check Flutter installation
flutter doctor

# Clean project
flutter clean

# Get dependencies
flutter pub get

# Build debug APK
flutter build apk --debug

# Build release APK
flutter build apk --release

# Build split APKs (smaller size)
flutter build apk --split-per-abi --release
```

## Testing the APK

1. **Transfer to Android device**:
   - Copy the APK file to your Android device
   - Enable "Install from unknown sources" in device settings
   - Install the APK

2. **Test on emulator**:
   - Start Android emulator
   - Run `flutter install` to install directly

## Firebase Configuration (Optional)

For full functionality, configure Firebase:

1. Follow `firebase_setup_guide.md`
2. Download `google-services.json`
3. Place in `android/app/` directory
4. Update `lib/firebase_options.dart`

## APK Size Optimization

To reduce APK size:

```bash
# Build split APKs
flutter build apk --split-per-abi --release

# Enable R8 optimization
flutter build apk --release --obfuscate --split-debug-info=build/debug-info
```

## Distribution

The generated APK can be:
- Installed directly on Android devices
- Distributed via email or file sharing
- Uploaded to app stores (with proper signing)
- Used for beta testing

---

**Note**: The APK will work without Firebase configuration for basic UI testing, but features like authentication, chat, and data storage will require Firebase setup. 