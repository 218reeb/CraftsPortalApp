# Web Build Instructions (Alternative to APK)

If you want to test the app without building an APK, you can create a web version:

## Prerequisites

1. **Flutter SDK** (same installation as for APK)
2. **Web browser** (Chrome recommended)

## Build Web Version

1. **Enable web support**:
   ```bash
   flutter config --enable-web
   ```

2. **Build for web**:
   ```bash
   flutter build web
   ```

3. **Serve locally**:
   ```bash
   flutter run -d chrome
   ```

## Web Build Location

The web build will be in:
```
build/web/
```

You can deploy this to:
- GitHub Pages
- Firebase Hosting
- Netlify
- Any web hosting service

## Limitations of Web Version

- Some mobile-specific features may not work
- Camera and file picker may have limitations
- Performance may differ from mobile app
- Firebase configuration still required for full functionality

## Deploy to Firebase Hosting

1. **Install Firebase CLI**:
   ```bash
   npm install -g firebase-tools
   ```

2. **Login to Firebase**:
   ```bash
   firebase login
   ```

3. **Initialize hosting**:
   ```bash
   firebase init hosting
   ```

4. **Deploy**:
   ```bash
   firebase deploy
   ```

This will give you a live web version of your app! 