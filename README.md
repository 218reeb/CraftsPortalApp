# Crafts Portal - Flutter Mobile Application

A professional mobile application designed to connect craftsmen with customers, built with Flutter and Firebase.

## 🎯 Overview

Crafts Portal is a comprehensive mobile application that serves as a marketplace connecting skilled craftsmen with customers looking for unique, handmade products. The app features real-time messaging, project showcases, user profiles, and a robust search system.

## ✨ Features

### 👥 User System
- **Dual User Types**: Craftsmen and Customers
- **Registration**: Email/password authentication with user type selection
- **Profile Management**: Editable profiles with images, bios, and location
- **Craft Categories**: Craftsmen must select their specialty during registration

### 🧰 Craftsman Features
- **Profile Management**: Edit name, bio, craft type, and profile image
- **Project Showcase**: Upload and manage projects with multiple images
- **Real-time Messaging**: Chat with customers
- **Dashboard**: View statistics and recent activity

### 👤 Customer Features
- **Browse Craftsmen**: Search by category or location
- **View Projects**: Explore craftsmen's work portfolios
- **Real-time Chat**: Initiate and continue conversations
- **Search & Filter**: Advanced search functionality

### 💬 Chat System
- **Real-time Messaging**: Instant message delivery
- **Message History**: Persistent chat threads
- **Read Status**: Message read indicators
- **User-to-User**: Direct communication between users

### 🔐 Authentication
- **Firebase Authentication**: Secure email/password login
- **User Data Storage**: Firestore integration for user profiles
- **Session Management**: Automatic login state handling

## 🛠️ Technical Stack

### Frontend
- **Flutter**: Cross-platform mobile development
- **Provider**: State management
- **Material Design**: Modern UI components
- **Custom Widgets**: Reusable UI components

### Backend
- **Firebase Firestore**: NoSQL database for user data, projects, and chats
- **Firebase Storage**: Image and file storage
- **Firebase Authentication**: User authentication
- **Real-time Updates**: Live data synchronization

### Dependencies
- `firebase_core`: Firebase initialization
- `firebase_auth`: Authentication
- `cloud_firestore`: Database operations
- `firebase_storage`: File storage
- `provider`: State management
- `image_picker`: Image selection
- `cached_network_image`: Image caching
- `intl`: Date formatting
- `geolocator`: Location services

## 📱 Screenshots

*Screenshots will be added after the app is built and tested*

## 🚀 Getting Started

### Prerequisites

1. **Flutter SDK**: Install Flutter (version 3.0.0 or higher)
   ```bash
   flutter doctor
   ```

2. **Android Studio / VS Code**: Your preferred IDE
3. **Firebase Account**: Create a Firebase project

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/crafts-portal.git
   cd crafts-portal
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   
   a. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   
   b. Enable Authentication with Email/Password
   
   c. Create a Firestore database
   
   d. Enable Storage
   
   e. Download `google-services.json` and place it in `android/app/`
   
   f. Update `lib/firebase_options.dart` with your Firebase configuration

4. **Configure Firebase Options**
   
   Replace the placeholder values in `lib/firebase_options.dart` with your actual Firebase project settings:
   ```dart
   static const FirebaseOptions android = FirebaseOptions(
     apiKey: 'YOUR_ANDROID_API_KEY',
     appId: 'YOUR_ANDROID_APP_ID',
     messagingSenderId: 'YOUR_SENDER_ID',
     projectId: 'YOUR_PROJECT_ID',
     storageBucket: 'YOUR_PROJECT_ID.appspot.com',
   );
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── models/                   # Data models
│   ├── user_model.dart
│   ├── project_model.dart
│   └── chat_model.dart
├── providers/                # State management
│   ├── auth_provider.dart
│   ├── user_provider.dart
│   └── chat_provider.dart
├── screens/                  # UI screens
│   ├── splash_screen.dart
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── main_screen.dart
│   ├── craftsman/
│   │   ├── craftsman_home_screen.dart
│   │   ├── craftsman_projects_screen.dart
│   │   ├── craftsman_chats_screen.dart
│   │   ├── craftsman_profile_screen.dart
│   │   └── add_project_screen.dart
│   ├── customer/
│   │   ├── customer_home_screen.dart
│   │   ├── customer_search_screen.dart
│   │   ├── customer_chats_screen.dart
│   │   └── customer_profile_screen.dart
│   └── chat/
│       └── chat_screen.dart
├── widgets/                  # Reusable widgets
│   ├── custom_text_field.dart
│   ├── custom_button.dart
│   ├── project_card.dart
│   └── craftsman_card.dart
└── utils/
    └── theme.dart           # App theme configuration
```

## 🔧 Configuration

### Firebase Security Rules

Set up Firestore security rules:

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
  }
}
```

### Storage Rules

Set up Firebase Storage rules:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

## 📦 Building for Production

### Android APK

1. **Build release APK**
   ```bash
   flutter build apk --release
   ```

2. **Find the APK**
   The APK will be located at: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (AAB)

1. **Build app bundle**
   ```bash
   flutter build appbundle --release
   ```

2. **Find the AAB**
   The AAB will be located at: `build/app/outputs/bundle/release/app-release.aab`

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter test integration_test
```

## 🚀 Deployment

### Google Play Store

1. Create a Google Play Console account
2. Upload the AAB file
3. Fill in app details, screenshots, and descriptions
4. Submit for review

### Firebase App Distribution

1. Upload APK to Firebase App Distribution
2. Invite testers via email
3. Testers receive download links

## 🔒 Security Considerations

- All user data is stored securely in Firebase
- Authentication is handled by Firebase Auth
- Images are stored in Firebase Storage with proper access controls
- Real-time data is protected by Firestore security rules

## 🐛 Troubleshooting

### Common Issues

1. **Firebase not initialized**
   - Ensure `google-services.json` is in the correct location
   - Check Firebase configuration in `firebase_options.dart`

2. **Permission denied errors**
   - Verify Firestore security rules
   - Check Storage rules for image uploads

3. **Build errors**
   - Run `flutter clean` and `flutter pub get`
   - Ensure all dependencies are compatible

4. **Image upload issues**
   - Check camera and storage permissions
   - Verify Firebase Storage configuration

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For support and questions:
- Create an issue in the GitHub repository
- Contact the development team

## 🔄 Version History

- **v1.0.0**: Initial release with core features
  - User authentication
  - Craftsman and customer profiles
  - Project management
  - Real-time messaging
  - Search and filtering

## 🎉 Acknowledgments

- Flutter team for the amazing framework
- Firebase for the backend services
- The open-source community for various packages

---

**Note**: This is a complete Flutter application ready for development and deployment. Make sure to configure Firebase properly before running the app. 