# Skills and Technologies Required for Madadgar App

## Overview
**Project**: Madadgar (Hyperlocal Errand Assistance App)  
**Timeline**: 2 weeks (MVP)  
**Team**: Solo Developer  
**Platform**: Flutter (iOS + Android)  
**Backend**: Firebase

---

## Core Skills Required

### 1. **Flutter & Dart Development** ⭐⭐⭐⭐⭐
- **What You'll Do**: Build entire UI/UX, handle navigation, manage app lifecycle
- **Priority**: CRITICAL (Must-have for MVP)
- **Topics**:
  - Widget composition and state management
  - Navigation (GoRouter or Navigator 2.0)
  - Async/await and Futures
  - Stream handling
  - Custom widget creation
- **Time Allocation**: 40% of your time

### 2. **Riverpod State Management** ⭐⭐⭐⭐
- **What You'll Do**: Manage app state (auth, tasks, user location, chat)
- **Priority**: CRITICAL (MVP backbone)
- **Topics**:
  - StateNotifierProvider, FutureProvider, StreamProvider
  - AsyncValue handling
  - Dependency injection via Riverpod
  - Combining multiple providers
- **Resources**: [Riverpod Docs](https://riverpod.dev)
- **Time Allocation**: 20% of your time

### 3. **Firebase Integration** ⭐⭐⭐⭐⭐
- **What You'll Do**: Auth (OTP), Firestore CRUD, FCM notifications, Cloud Functions triggers
- **Priority**: CRITICAL
- **Topics**:
  - Firebase Auth with phone number verification
  - Firestore queries, transactions, real-time listeners
  - FCM token management & push notifications
  - Firebase Storage (profile photos, CNIC images)
  - Cloud Functions debugging
- **Packages**: `firebase_core`, `cloud_firestore`, `firebase_auth`, `firebase_messaging`, `firebase_storage`
- **Time Allocation**: 25% of your time

### 4. **Geolocation & Maps** ⭐⭐⭐⭐
- **What You'll Do**: Real-time location tracking, task discovery via geohash queries, map pickers
- **Priority**: CRITICAL (core feature)
- **Topics**:
  - Geolocator permissions and background location updates
  - Google Maps Flutter integration
  - GeoFlutterFire2 for geohash-based queries
  - Reverse geocoding (address from coordinates)
  - Map markers and polylines for helper tracking
- **Packages**: `geolocator`, `google_maps_flutter`, `geo_firebase_flutter`, `geocoding`
- **Time Allocation**: 10% of your time

### 5. **Google ML Kit (OCR for CNIC)** ⭐⭐⭐
- **What You'll Do**: Extract text from CNIC photos, parse CNIC number format
- **Priority**: HIGH (for helper verification MVP)
- **Approach**: 
  - Built into Flutter, works offline
  - Free, no API costs
  - Extracts text from CNIC image
  - You write the logic to parse the CNIC number format yourself
- **Topics**:
  - Image picker and camera integration
  - ML Kit Text Recognition
  - CNIC format parsing (Pakistani format: 5 digits - 7 digits - 1 digit - 1 checksum)
  - Error handling for poor quality images
- **Packages**: `google_mlkit_text_recognition`, `image_picker`, `image_cropper`
- **Time Allocation**: 5% of your time

### 6. **In-App Chat & Real-time Communication** ⭐⭐⭐
- **What You'll Do**: Firestore message subcollections, real-time listeners, message UI
- **Priority**: HIGH
- **Topics**:
  - Firestore subcollections (chats/{taskId}/messages)
  - StreamBuilder for real-time updates
  - Timestamp handling and message ordering
  - Read/unread status tracking
- **Time Allocation**: 5% of your time

### 7. **UI/UX Design & Responsive Layout** ⭐⭐⭐⭐
- **What You'll Do**: Create intuitive screens for both customer and helper flows
- **Priority**: HIGH (user experience critical)
- **Topics**:
  - Material Design 3 / Material 3
  - Responsive layouts (MediaQuery, LayoutBuilder)
  - Custom animations and transitions
  - Bottom sheets, dialogs, snackbars
  - Bilingual support (English/Urdu) with Flutter Localizations
- **Packages**: `flutter_localizations`, `intl`, `flutter_animate` (optional)
- **Time Allocation**: 10% of your time

### 8. **Testing** ⭐⭐
- **What You'll Do**: Unit tests for utilities & validators, widget tests for critical screens
- **Priority**: MEDIUM (focus on high-risk areas only for MVP)
- **Topics**:
  - Flutter test framework (unit & widget tests)
  - Mocking Firestore and Firebase Auth
  - Testing Riverpod providers
- **Packages**: `mockito`, `flutter_test`
- **Time Allocation**: 2% of your time (or skip for strict MVP)

### 9. **Git & Version Control** ⭐⭐⭐
- **What You'll Do**: Commit code, track changes, rollback if needed
- **Priority**: MEDIUM
- **Topics**:
  - Git branching strategy (feature branches)
  - Meaningful commit messages
  - .gitignore for Firebase keys
- **Time Allocation**: 3% of your time

### 10. **Performance & Debugging** ⭐⭐⭐
- **What You'll Do**: Optimize queries, reduce rebuilds, use DevTools
- **Priority**: MEDIUM (catch later in development)
- **Topics**:
  - Flutter DevTools and Dart DevTools
  - Firestore query optimization (indexes, pagination)
  - Provider watch/select patterns to avoid unnecessary rebuilds
  - Memory profiling
- **Time Allocation**: 3% of your time

---

## Technologies & Packages (MVP Stack)

### Core Framework
| Package | Purpose | Notes |
|---------|---------|-------|
| `flutter` | Mobile framework | Latest stable channel |
| `dart` | Language | Included with Flutter |

### State Management
| Package | Purpose | Version |
|---------|---------|---------|
| `riverpod` | Provider-based state management | ^2.x |
| `flutter_riverpod` | Flutter integration for Riverpod | ^2.x |
| `riverpod_generator` | Code generation for providers | ^2.x |

### Firebase & Backend
| Package | Purpose | Notes |
|---------|---------|-------|
| `firebase_core` | Firebase initialization | ^27.x+ |
| `firebase_auth` | OTP authentication | ^5.x+ |
| `cloud_firestore` | Real-time database | ^5.x+ |
| `firebase_storage` | File storage (photos, CNIC) | ^12.x+ |
| `firebase_messaging` | Push notifications (FCM) | ^15.x+ |

### Geolocation & Maps
| Package | Purpose | Notes |
|---------|---------|-------|
| `google_maps_flutter` | Interactive maps | ^2.x |
| `geolocator` | Location services | ^11.x |
| `geo_firebase_flutter` | Geohash queries for task discovery | ^0.3.x |
| `geocoding` | Address ↔ Coordinates conversion | ^3.x |

### ML Kit (CNIC OCR)
| Package | Purpose | Notes |
|---------|---------|-------|
| `google_mlkit_text_recognition` | Extract text from CNIC images | ^0.x |
| `image_picker` | Camera & gallery access | ^1.x |
| `image_cropper` | Crop CNIC photos | ^7.x |

### UI & UX
| Package | Purpose | Notes |
|---------|---------|-------|
| `flutter_localizations` | i18n support (English/Urdu) | Built-in |
| `intl` | Localization utilities | ^0.x |
| `go_router` | Modern routing | ^14.x (or `auto_route`) |
| `flutter_animate` | Smooth animations | ^4.x (optional) |
| `shimmer` | Loading placeholders | ^3.x |
| `cached_network_image` | Image caching | ^3.x |

### Utilities
| Package | Purpose | Notes |
|---------|---------|-------|
| `connectivity_plus` | Check internet connection | ^6.x |
| `package_info_plus` | App version info | ^5.x |
| `flutter_secure_storage` | Store sensitive data locally | ^9.x |
| `uuid` | Generate unique IDs | ^4.x |

### Testing (Optional for MVP)
| Package | Purpose | Notes |
|---------|---------|-------|
| `mockito` | Mocking framework | ^5.x |
| `flutter_test` | Built-in testing | Included with Flutter |

---

## Firebase Configuration Steps

### Step 1: Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Create a project" → Enter "madadgar"
3. Enable Google Analytics (optional)
4. Wait for project to initialize

### Step 2: Register Apps (iOS & Android)

**For Android:**
1. Click "Add App" → Select Android
2. Package name: `com.madadgar.app` (or your choice)
3. Download `google-services.json`
4. Place it in `android/app/`
5. Follow on-screen instructions to add gradle plugins

**For iOS:**
1. Click "Add App" → Select iOS
2. Bundle ID: `com.madadgar.app`
3. Download `GoogleService-Info.plist`
4. Add to Xcode project (Xcode → File → Add Files → select plist)
5. Ensure it's added to all targets

### Step 3: Enable Authentication
1. Firebase Console → Authentication → Sign-in method
2. Enable "Phone" authentication
3. Add your phone number to testers (for development)

### Step 4: Create Firestore Database
1. Firebase Console → Firestore Database → Create Database
2. Select region: `asia-south1` (closest to Pakistan)
3. Start in test mode (will lock it down later)

### Step 5: Set Up Cloud Storage
1. Firebase Console → Storage → Get Started
2. Choose the same region: `asia-south1`

### Step 6: Enable Cloud Messaging (FCM)
1. Firebase Console → Cloud Messaging → Web configuration appears automatically
2. Note your `Server Key` (you'll need this for Cloud Functions)

### Step 7: Cloud Functions Setup (Optional for MVP)
1. Firebase Console → Functions → Get Started
2. Deploy sample function to test connectivity
3. You can use `firebase-tools` CLI:
   ```bash
   npm install -g firebase-tools
   firebase login
   firebase init functions
   ```

---

## 2-Week Development Roadmap

**See `roadmap.md` file for detailed sprint breakdown.**

---

## Learning Resources by Topic

### Flutter & Dart
- [Flutter Official Docs](https://flutter.dev/docs)
- [Dart Language Guide](https://dart.dev/guides)
- YouTube: *Flutter Complete Course* by Udemy (freeCodeCamp)

### Riverpod
- [Riverpod Official Documentation](https://riverpod.dev)
- [Riverpod Generator Tutorial](https://riverpod.dev/docs/concepts/about_code_generation)

### Firebase
- [Firebase Flutter Setup](https://firebase.flutter.dev)
- [Firestore Best Practices](https://firebase.google.com/docs/firestore/best-practices)
- YouTube: *Firebase for Flutter* by FlutterFlow

### Google Maps & Geolocation
- [Google Maps Flutter Plugin](https://pub.dev/packages/google_maps_flutter)
- [Geolocator Package](https://pub.dev/packages/geolocator)
- [GeoFlutterFire2 Documentation](https://pub.dev/packages/geo_firebase_flutter)

### ML Kit OCR
- [Google ML Kit Flutter](https://github.com/google-mlkit-flutter/google_mlkit_flutter)
- [Text Recognition Guide](https://pub.dev/packages/google_mlkit_text_recognition)

### Riverpod + Firebase Integration
- [Riverpod Firebase Example](https://github.com/rrousselGit/riverpod/tree/master/examples/firebase_example)

---

## Priority Matrix (for 2-week MVP)

| Skill | Must-Have | Nice-to-Have | Time (hrs) |
|-------|-----------|--------------|-----------|
| Flutter basics | ✅ | - | 20 |
| Riverpod | ✅ | - | 15 |
| Firebase Auth + Firestore | ✅ | - | 20 |
| Google Maps + Geolocator | ✅ | - | 15 |
| In-App Chat (Firestore) | ✅ | - | 10 |
| FCM Push Notifications | ✅ | - | 8 |
| Google ML Kit OCR | ✅ | - | 8 |
| UI/UX & Animations | ✅ | - | 12 |
| Testing | - | ✅ | 5 |
| Performance Optimization | - | ✅ | 5 |
| **Total** | | | **~118 hours** |

**⏱️ Note**: 2 weeks = ~336 hours (accounting for breaks). You have **~2x the time needed**, so focus on quality over extras.

---

## Tips for Solo 2-Week Development

1. **Start with auth** (OTP login) — unblock other features
2. **Use Firebase emulator** locally to avoid quota limits during testing
3. **Design once, code twice** — spend 1 day on UI mockups before coding
4. **Avoid scope creep** — skip nice-to-haves (admin panel, advanced analytics)
5. **Test on a real device early** — emulator can miss location/camera issues
6. **Commit frequently** to Git (safety net)
7. **Use code generation** (Riverpod generator, Freezed for models) to save time