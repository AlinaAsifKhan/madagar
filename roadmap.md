# Madadgar Development Roadmap (2-Week MVP)

## Timeline Overview

```
Week 1: Foundation & Core Features
├── Days 1-2: Project Setup & Firebase Config
├── Days 3-4: Authentication (OTP + Profile Setup)
├── Days 5-7: Task Management (Post/Browse/Accept)

Week 2: Real-time Features & Polish
├── Days 8-9: Geolocation & Maps Integration
├── Days 10-11: Chat, Notifications & Rating
├── Days 12-13: CNIC OCR & Helper Verification
├── Day 14: Testing, Bug Fixes & Deployment Prep
```

---

## Week 1: Foundation & Core Features

### Day 1-2: Project Setup & Firebase Configuration

**Objectives:**
- [ ] Initialize Flutter project structure
- [ ] Configure Firebase for both Android & iOS
- [ ] Set up Riverpod and code generation
- [ ] Create base app architecture

**Tasks:**

1. **Create Flutter Project**
   ```bash
   flutter create madadgar
   cd madadgar
   ```

2. **Add Dependencies to `pubspec.yaml`**
   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     # Firebase
     firebase_core: ^27.0.0
     firebase_auth: ^5.0.0
     cloud_firestore: ^5.0.0
     firebase_messaging: ^14.7.0
     firebase_storage: ^12.1.0
     # Riverpod
     flutter_riverpod: ^2.4.0
     riverpod_generator: ^2.3.0
     # Routing
     go_router: ^14.0.0
     # Localization
     flutter_localizations:
       sdk: flutter
     intl: ^0.19.0
     # Maps & Location
     google_maps_flutter: ^2.5.0
     geolocator: ^11.0.0
     geocoding: ^3.0.0
     geo_firebase_flutter: ^0.3.0
     # ML Kit
     google_mlkit_text_recognition: ^0.7.0
     image_picker: ^1.0.0
     image_cropper: ^7.0.0
     # Utils
     connectivity_plus: ^6.0.0
     flutter_secure_storage: ^9.0.0
     uuid: ^4.0.0
     cached_network_image: ^3.3.0
     shimmer: ^3.0.0
   dev_dependencies:
     build_runner: ^2.4.0
     riverpod_generator: ^2.3.0
     mockito: ^5.4.0
   ```

3. **Configure Firebase (Android)**
   - Download `google-services.json` from Firebase Console
   - Place in `android/app/`
   - Update `android/build.gradle`:
     ```gradle
     dependencies {
       classpath 'com.google.gms:google-services:4.3.15'
     }
     ```
   - Update `android/app/build.gradle`:
     ```gradle
     apply plugin: 'com.google.gms.google-services'
     ```

4. **Configure Firebase (iOS)**
   - Download `GoogleService-Info.plist` from Firebase Console
   - Add to Xcode via File → Add Files
   - Update `ios/Podfile` to support Firebase
   - Run `flutter pub get && flutter pub run build_runner build`

5. **Create Project Structure**
   ```
   lib/
   ├── core/
   │   ├── constants/
   │   ├── utils/
   │   └── widgets/
   ├── features/
   │   ├── auth/
   │   ├── tasks/
   │   ├── location/
   │   ├── chat/
   │   └── profile/
   ├── firebase_options.dart
   ├── main.dart
   └── app.dart
   ```

6. **Initialize Firebase in `main.dart`**
   ```dart
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp(
       options: DefaultFirebaseOptions.currentPlatform,
     );
     runApp(
       ProviderScope(child: const MyApp()),
     );
   }
   ```

**Deliverables:**
- ✅ Project compiles and runs on emulator/device
- ✅ Firebase connected and verified
- ✅ Riverpod providers set up
- ✅ Base project structure ready

**Time**: 4 hours

---

### Day 3-4: Authentication (OTP + Profile Setup)

**Objectives:**
- [ ] Implement phone number OTP login
- [ ] Create profile setup screen
- [ ] Handle first-time vs. returning users
- [ ] Implement role switching (Customer/Helper)

**Tasks:**

1. **Create Auth Service (Riverpod Provider)**
   ```dart
   // lib/features/auth/data/firebase_auth_service.dart
   // - Phone OTP verification
   // - User creation in Firestore
   // - FCM token storage
   ```

2. **Auth Screens**
   - [ ] Splash Screen (2s delay → navigate based on auth state)
   - [ ] Welcome Screen (Customer / Helper / Both options)
   - [ ] Phone Entry Screen (+92 format, validation)
   - [ ] OTP Verification Screen (6 digits, 60s countdown, resend)
   - [ ] Profile Setup Screen (name, photo upload, role selection)

3. **Create Auth State Notifier**
   ```dart
   // lib/features/auth/providers/auth_provider.dart
   class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
     // Handle auth state changes
     // Manage OTP verification
     // Store FCM token
   }
   ```

4. **Firestore User Document Creation**
   ```dart
   // After auth success, create user doc with:
   // - uid, phone, name, role, profilePhotoUrl
   // - isHelperVerified: false (for helpers)
   // - geohash: null (updated on location access)
   // - createdAt: timestamp
   ```

5. **Handle Edge Cases**
   - [ ] OTP timeout (show resend button)
   - [ ] Wrong OTP attempts (Firebase handles rate limiting)
   - [ ] Banned user detection
   - [ ] Phone number change (not supported in MVP)

**Deliverables:**
- ✅ Complete auth flow working
- ✅ OTP sends/verifies correctly
- ✅ User document created in Firestore
- ✅ Role selection working
- ✅ FCM token stored

**Time**: 8 hours

**Screenshot Goals:**
- Splash → Welcome → Phone Entry → OTP → Profile Setup → Home

---

### Day 5-7: Task Management (Post/Browse/Accept)

**Objectives:**
- [ ] Customer can post tasks
- [ ] Helper can browse nearby tasks
- [ ] Task acceptance with race condition handling
- [ ] Real-time task status updates

**Tasks:**

1. **Task Data Model (Freezed for immutability)**
   ```dart
   // lib/features/tasks/domain/models/task.dart
   @freezed
   class Task with _$Task {
     const factory Task({
       required String taskId,
       required String customerId,
       required String title,
       required String description,
       required String category,
       required double estimatedItemCost,
       required double helperFee,
       required GeoPoint pickupLocation,
       required String pickupAddress,
       required GeoPoint deliveryLocation,
       required String deliveryAddress,
       required String status, // posted, accepted, etc.
       String? helperId,
       String? helperName,
       List<String>? photoUrls,
       required DateTime createdAt,
       DateTime? completedAt,
     }) = _Task;
   }
   ```

2. **Customer: Post Task Screen**
   - [ ] Form: title, description, category dropdown (6 categories)
   - [ ] Map pickers for pickup & delivery (GeoPoint selection)
   - [ ] Photo upload (max 3 images → Firebase Storage)
   - [ ] Cost breakdown: Item Cost + Helper Fee = Total
   - [ ] Submit button → Create task doc in Firestore
   - [ ] Show success confirmation

3. **Helper: Browse Tasks Screen**
   - [ ] List view of nearby `posted` tasks within 5km
   - [ ] Task card: category badge, distance, title, helper fee
   - [ ] Filter by distance slider (2/5/10 km)
   - [ ] "Accept Task" button → Firestore transaction (check status still `posted`)
   - [ ] Error handling: "Task already taken by another helper"

4. **Real-time Task Updates (Riverpod StreamProvider)**
   ```dart
   // Listen to task status changes in real-time
   final taskStreamProvider = StreamProvider.family
     .autoDispose<Task, String>((ref, taskId) {
     // Return stream of task updates
   });
   ```

5. **Task Acceptance with Transaction**
   ```dart
   // Use Firestore transaction to prevent race conditions
   // Check: status == "posted"
   // Update: status → "accepted", helperId, helperName
   ```

6. **Customer Home Screen**
   - [ ] Show active task card (if any)
   - [ ] Show recent completed/cancelled tasks list
   - [ ] FAB: "Post a Task" button

7. **Helper Home Screen**
   - [ ] Map view with task pins (clickable)
   - [ ] Toggle list view
   - [ ] Task acceptance flow

**Deliverables:**
- ✅ Customer can post tasks successfully
- ✅ Tasks appear in Firestore with all fields
- ✅ Helper can browse nearby tasks
- ✅ Task acceptance works (real transaction)
- ✅ Race condition handled (only first helper gets task)
- ✅ Real-time updates visible

**Time**: 12 hours

**Testing:**
- [ ] Post task → verify Firestore document
- [ ] Accept task as helper → verify helper assignment
- [ ] Try accepting same task twice → second fails gracefully

---

## Week 2: Real-time Features & Polish

### Day 8-9: Geolocation & Maps Integration

**Objectives:**
- [ ] Real-time helper location tracking
- [ ] Geohash-based task discovery
- [ ] Map visualization of helper location
- [ ] Distance calculations

**Tasks:**

1. **Location Service (Geolocator + Geohash)**
   ```dart
   // lib/features/location/data/geolocator_service.dart
   // - Request permissions (location, background)
   // - Get current location
   // - Start background stream (10s intervals during active task)
   // - Stop location updates when task completes
   ```

2. **Geohash for Task Discovery (GeoFlutterFire2)**
   ```dart
   // When helper opens app:
   // - Get their location
   // - Compute geohash
   // - Query Firestore for nearby tasks within 5km
   // - Convert GeoPoint to distance in km
   ```

3. **Helper Location Updates During Active Task**
   - [ ] When task status → `accepted`, start background location stream
   - [ ] Update `users/{helperId}.currentLocation` every 10 seconds
   - [ ] Customer's task detail screen listens to this in real-time
   - [ ] Display helper's real-time position on map

4. **Map Picker for Task Creation**
   - [ ] Full-screen Google Map for pickup location
   - [ ] Full-screen Google Map for delivery location
   - [ ] Reverse geocoding: GeoPoint → human-readable address
   - [ ] Store both `GeoPoint` (for geohash queries) and `String address` (for display)

5. **Real-time Helper Tracking (Customer View)**
   - [ ] Task Detail Screen shows map with helper's current location
   - [ ] Update map marker every time `currentLocation` changes
   - [ ] Show distance/ETA to delivery location

6. **Location Permission Handling**
   - [ ] Request `locationWhenInUse` on app start
   - [ ] Request `locationAlways` for background tracking (iOS specific)
   - [ ] Show dialog if denied: "Location needed for geolocation features"
   - [ ] Link to app settings

**Deliverables:**
- ✅ Helper can grant location permissions
- ✅ Background location updates working (test on real device)
- ✅ Map shows helper's real-time location
- ✅ Task discovery works via geohash queries
- ✅ Address geocoding working

**Time**: 10 hours

**Testing:**
- [ ] Verify geohash queries return nearby tasks
- [ ] Background location updates on real device (emulator won't show)
- [ ] Map updates in real-time as helper moves

---

### Day 10-11: Chat, Notifications & Rating

**Objectives:**
- [ ] In-app chat between customer & helper
- [ ] Firebase Cloud Messaging (FCM) notifications
- [ ] Helper rating system (1-5 stars)

**Tasks:**

1. **In-App Chat (Firestore Subcollection)**
   ```dart
   // chats/{taskId}/messages/{messageId}
   // - senderId, text, timestamp, isRead
   // - Firestore listener for real-time messages
   // - Chat only active during: accepted, item_purchased, delivery_in_progress
   ```

2. **Chat Screen**
   - [ ] Message list (oldest at bottom, newest at top)
   - [ ] Message input field with send button
   - [ ] Real-time message updates (StreamBuilder)
   - [ ] Mark messages as read
   - [ ] Show sender info (name, avatar)

3. **FCM Push Notifications**
   - [ ] Store FCM token in `users/{userId}.fcmToken` on login
   - [ ] Trigger notifications for:
     - Task posted (nearby helpers)
     - Task accepted (customer)
     - Status changes (item_purchased, delivery_in_progress)
     - New chat message
     - Task completed
   - [ ] Handle notification tap → navigate to relevant screen

4. **Cloud Functions (Firebase) - Triggers**
   ```javascript
   // onTaskCreated() → send to nearby helpers
   // onTaskAccepted() → send to customer
   // onMessageCreated() → send to other party
   // onTaskCompleted() → send to helper
   ```
   *Note: Set up basic Cloud Functions triggers. Can be enhanced later.*

5. **Rating System**
   - [ ] After task completion, show "Rate Helper" modal
   - [ ] Star picker (1-5) + optional comment
   - [ ] Submit rating → create document in `ratings` collection
   - [ ] Cloud Function recalculates `users/{helperId}.averageRating`

6. **Rating Display**
   - [ ] Show helper's average rating on helper profile
   - [ ] Show helper's rating on task detail (customer view)

**Deliverables:**
- ✅ Chat working between customer & helper in real-time
- ✅ FCM notifications sent & received correctly
- ✅ Rating system functional
- ✅ Helper's average rating updates after rating submitted

**Time**: 8 hours

**Testing:**
- [ ] Send message → appears real-time in other user's chat
- [ ] Complete task → rating modal appears
- [ ] Submit rating → new rating reflected in database

---

### Day 12-13: CNIC OCR & Helper Verification

**Objectives:**
- [ ] CNIC photo capture/upload
- [ ] Google ML Kit text extraction
- [ ] Parse CNIC number format
- [ ] Verification workflow

**Tasks:**

1. **CNIC Verification UI**
   - [ ] Helper profile screen: "Complete Verification" section
   - [ ] Camera/gallery picker for CNIC front & back photos
   - [ ] Image cropper to ensure good quality
   - [ ] Preview before upload

2. **Google ML Kit OCR**
   ```dart
   // lib/features/profile/data/ml_kit_service.dart
   // - Take image file
   // - Extract text using ML Kit
   // - Parse CNIC format (xxxxx-xxxxxxx-x-x)
   // - Return parsed CNIC number or error
   ```

3. **CNIC Format Parsing**
   ```dart
   // Pakistani CNIC format: 12345-6789012-1-2
   // Regex: ^\d{5}-\d{7}-\d-\d$
   ```

4. **Upload CNIC Images**
   - [ ] Upload to Firebase Storage: `cnic/{userId}/front.jpg`, `cnic/{userId}/back.jpg`
   - [ ] Store `isHelperVerified: false` (pending admin review in MVP)
   - [ ] Show: "Verification pending. Please wait for admin approval."

5. **Verification Status UI**
   - [ ] Unverified helpers: show banner "Complete verification to accept tasks"
   - [ ] Cannot tap "Accept Task" button until verified
   - [ ] Verified: "Your account is verified ✓"

6. **Cloud Function for Auto-approval (Optional)**
   - For MVP, manual admin review via Firebase Console
   - Set `isHelperVerified: true` directly

**Deliverables:**
- ✅ CNIC capture & image cropping working
- ✅ ML Kit text extraction working
- ✅ CNIC format parsing functional
- ✅ Images uploaded to Firebase Storage
- ✅ Verification status tracked
- ✅ Unverified helpers blocked from accepting tasks

**Time**: 8 hours

**Testing:**
- [ ] Take CNIC photo → ML Kit extracts text
- [ ] Verify CNIC number parsing works
- [ ] Upload → images stored in Firebase Storage
- [ ] Before verification: cannot accept tasks

---

### Day 14: Testing, Bug Fixes & Deployment Prep

**Objectives:**
- [ ] Bug fixes and edge case handling
- [ ] Performance testing
- [ ] Prepare for App Store / Play Store submission
- [ ] Documentation

**Tasks:**

1. **End-to-End Testing**
   - [ ] Complete customer flow: login → post task → rate helper
   - [ ] Complete helper flow: login → browse → accept → track → complete
   - [ ] Chat flow between customer & helper
   - [ ] Notification delivery verification

2. **Edge Case Testing**
   - [ ] Network disconnect → reconnect (verify Firestore offline persistence)
   - [ ] App crash during task → relaunch and restore state
   - [ ] Same task accepted by two helpers (verify transaction prevents this)
   - [ ] OTP timeout and resend
   - [ ] Background location updates (real device)

3. **Performance & Optimization**
   - [ ] Check Firestore query efficiency (ensure indexes created)
   - [ ] Test with multiple concurrent users (Firebase emulator)
   - [ ] Monitor memory usage (DevTools)
   - [ ] Optimize large lists with pagination

4. **Firebase Security Rules (Lock Down)**
   ```javascript
   // Update Firestore rules from "test mode" to production
   // Ensure users can only read/write their own documents
   // Helpers can only accept posted tasks
   // Customers can only rate completed tasks
   ```

5. **Build APK & IPA**
   ```bash
   # Android
   flutter build apk --release
   
   # iOS
   flutter build ios --release
   ```

6. **Documentation**
   - [ ] Update `README.md` with setup instructions
   - [ ] Document environment variables (Firebase config)
   - [ ] Create deployment guide

7. **Final QA Checklist**
   - [ ] All screens navigate correctly
   - [ ] No console errors or warnings
   - [ ] Firestore data structured correctly
   - [ ] Images and assets load properly
   - [ ] Font sizes readable on small screens
   - [ ] Buttons and inputs accessible

**Deliverables:**
- ✅ All bugs fixed
- ✅ App tested end-to-end
- ✅ Firebase rules locked down (not in test mode)
- ✅ Release builds created (APK & IPA)
- ✅ Documentation complete
- ✅ Ready for App Store / Play Store submission

**Time**: 6 hours

---

## Success Metrics (End of Week 2)

| Feature | Status |
|---------|--------|
| ✅ OTP Authentication | Fully functional |
| ✅ Task Posting (Customer) | Fully functional |
| ✅ Task Browsing (Helper) | Fully functional |
| ✅ Task Acceptance | Fully functional |
| ✅ Real-time Location Tracking | Fully functional |
| ✅ In-App Chat | Fully functional |
| ✅ FCM Notifications | Fully functional |
| ✅ Rating System | Fully functional |
| ✅ CNIC OCR Verification | Fully functional |
| ✅ Role Switching | Fully functional |
| ✅ Bilingual UI (English/Urdu) | Partially complete (can enhance) |
| ✅ Firebase Integration | Fully functional |

---

## Post-MVP Enhancements (Future)

1. **Payment Integration**: Add in-app payment (Stripe / JazzCash)
2. **Advanced Filtering**: Filter tasks by category, price range
3. **Admin Panel**: Web-based dashboard for dispute resolution
4. **Analytics**: Track user behavior, task completion rates
5. **Push Notification Refinement**: Segmentation and personalization
6. **Multilingual Support**: Expand to more languages
7. **Performance**: Firestore indexing, query optimization
8. **Testing**: Comprehensive unit and widget test coverage

---

## Notes for Solo Developer

- **Focus on core features** — don't build admin panel or analytics in Week 1
- **Use Firebase emulator** for faster local testing
- **Commit to Git frequently** (at least daily)
- **Take breaks** — 2 weeks is intense; maintain productivity with rest
- **Test on real devices** (especially for location & camera features)
- **Keep scope tight** — cut any feature that isn't in the MVP spec
- **Document code** — future-you will thank you

**Good luck! 🚀**
