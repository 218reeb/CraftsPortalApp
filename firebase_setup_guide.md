# Firebase Setup Guide for Crafts Portal

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or "Add project"
3. Enter project name: "Crafts Portal"
4. Enable Google Analytics (optional)
5. Click "Create project"

## Step 2: Enable Authentication

1. In Firebase Console, go to "Authentication" → "Sign-in method"
2. Enable "Email/Password" provider
3. Click "Save"

## Step 3: Create Firestore Database

1. Go to "Firestore Database" → "Create database"
2. Choose "Start in test mode" (for development)
3. Select a location close to your users
4. Click "Done"

## Step 4: Enable Storage

1. Go to "Storage" → "Get started"
2. Choose "Start in test mode" (for development)
3. Select a location
4. Click "Done"

## Step 5: Add Android App

1. Go to "Project settings" (gear icon)
2. In "Your apps" section, click "Add app" → "Android"
3. Enter package name: `com.example.crafts_portal`
4. Enter app nickname: "Crafts Portal"
5. Click "Register app"
6. Download `google-services.json`
7. Place it in `android/app/` directory

## Step 6: Update Firebase Configuration

1. Open `lib/firebase_options.dart`
2. Replace all placeholder values with your actual Firebase project settings:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ACTUAL_ANDROID_API_KEY',
  appId: 'YOUR_ACTUAL_ANDROID_APP_ID',
  messagingSenderId: 'YOUR_ACTUAL_SENDER_ID',
  projectId: 'YOUR_ACTUAL_PROJECT_ID',
  storageBucket: 'YOUR_ACTUAL_PROJECT_ID.appspot.com',
);
```

## Step 7: Set Up Security Rules

### Firestore Rules
Go to Firestore Database → Rules and add:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Projects can be read by all, written by craftsmen
    match /projects/{projectId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.userType == 'craftsman';
    }
    
    // Chats can be read/written by participants
    match /chats/{chatId} {
      allow read, write: if request.auth != null && 
        (resource.data.participant1Id == request.auth.uid || 
         resource.data.participant2Id == request.auth.uid);
    }
    
    // Messages can be read/written by chat participants
    match /chats/{chatId}/messages/{messageId} {
      allow read, write: if request.auth != null && 
        (get(/databases/$(database)/documents/chats/$(chatId)).data.participant1Id == request.auth.uid || 
         get(/databases/$(database)/documents/chats/$(chatId)).data.participant2Id == request.auth.uid);
    }
  }
}
```

### Storage Rules
Go to Storage → Rules and add:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Users can upload their own profile images
    match /users/{userId}/profile/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Craftsmen can upload project images
    match /projects/{projectId}/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        firestore.get(/databases/(default)/documents/users/$(request.auth.uid)).data.userType == 'craftsman';
    }
  }
}
```

## Step 8: Test Configuration

1. Run `flutter pub get`
2. Run `flutter run`
3. Test registration and login functionality

## Troubleshooting

- If you get Firebase initialization errors, make sure `google-services.json` is in the correct location
- If authentication fails, check that Email/Password provider is enabled
- If database operations fail, check Firestore security rules
- If image upload fails, check Storage security rules

## Production Deployment

Before deploying to production:

1. Update security rules to be more restrictive
2. Enable additional authentication methods if needed
3. Set up proper error monitoring
4. Configure Firebase Hosting (optional)
5. Set up Firebase Analytics for user insights 