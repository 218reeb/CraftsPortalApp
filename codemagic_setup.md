# Codemagic APK Build Setup

## 🚀 Easiest Way to Get Your APK (No Installation Required)

Codemagic is a free service that will build your APK automatically. Here's how to use it:

## Step 1: Create GitHub Repository

1. **Go to GitHub**: https://github.com/new
2. **Repository name**: `crafts-portal`
3. **Make it Public**
4. **Don't initialize with README**
5. **Click "Create repository"**

## Step 2: Upload Your Code

### Option A: Using GitHub Desktop (Easiest)
1. **Download GitHub Desktop**: https://desktop.github.com/
2. **Clone your repository**
3. **Copy all project files** to the repository folder
4. **Commit and push** to GitHub

### Option B: Using Git Commands
```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/yourusername/crafts-portal.git
git push -u origin main
```

## Step 3: Connect to Codemagic

1. **Go to Codemagic**: https://codemagic.io/
2. **Sign up with GitHub**
3. **Click "Add application"**
4. **Select your repository**: `crafts-portal`
5. **Choose Flutter** as the project type
6. **Click "Finish"**

## Step 4: Configure Build

Codemagic will auto-detect your Flutter project. The default settings should work, but you can customize:

### Build Settings
- **Flutter version**: 3.16.0
- **Build platform**: Android
- **Build type**: Release

### Environment Variables (Optional)
```
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_APP_ID=your-app-id
```

## Step 5: Build APK

1. **Click "Start new build"**
2. **Wait for build to complete** (5-10 minutes)
3. **Download your APK** from the build artifacts

## Alternative: Use Codemagic CLI

If you prefer command line:

```bash
# Install Codemagic CLI
npm install -g codemagic-cli

# Login to Codemagic
codemagic login

# Build APK
codemagic build --app-id your-app-id --workflow android-release
```

## 🎯 Benefits of Codemagic

- ✅ **No local setup required**
- ✅ **Free for public repositories**
- ✅ **Automatic builds on every push**
- ✅ **Multiple build configurations**
- ✅ **Easy APK distribution**
- ✅ **Build history and logs**

## 📱 Getting Your APK

After the build completes:

1. **Go to your Codemagic dashboard**
2. **Click on the latest build**
3. **Download the APK** from artifacts
4. **Install on your Android device**

## 🔧 Troubleshooting

### Build Fails
- Check build logs for errors
- Ensure all dependencies are in `pubspec.yaml`
- Verify Firebase configuration (if using)

### APK Not Generated
- Make sure Android build is enabled
- Check that `android/app/build.gradle` is correct
- Verify Flutter version compatibility

### Firebase Issues
- Add Firebase configuration to environment variables
- Ensure `google-services.json` is in the repository
- Check Firebase project settings

## 🚀 Next Steps

Once you have your APK:

1. **Test on your device**
2. **Configure Firebase** for full functionality
3. **Customize the app** as needed
4. **Distribute to users**

## 📞 Support

- **Codemagic Documentation**: https://docs.codemagic.io/
- **Flutter Documentation**: https://flutter.dev/docs
- **GitHub Help**: https://help.github.com/

---

**This is the fastest way to get your APK without installing anything locally!** 