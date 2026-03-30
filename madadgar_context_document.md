# Madadgar – Hyperlocal Errand Assistance App
## Comprehensive Agent Context Document

---

## 1. Project Overview

**App Name:** Madadgar (meaning "Helper" in Urdu)
**Platform:** Flutter (iOS + Android)
**Backend:** Firebase (Firestore, Auth, Storage, Cloud Functions, FCM)
**Target Market:** Pakistan — primarily Lahore, Karachi, Islamabad

Madadgar connects users who need small errands completed with nearby helpers willing to perform those tasks for compensation. It addresses a gap in Pakistan's delivery ecosystem where many purchases happen from local vendors (fruit stalls, pharmacies, small shops) not covered by platforms like Daraz or Foodpanda.

---

## 2. Tech Stack

| Layer | Technology |
|-------|-----------|
| Mobile App | Flutter (Dart) |
| Authentication | Firebase Auth (phone number OTP) |
| Database | Cloud Firestore |
| File Storage | Firebase Storage |
| Push Notifications | Firebase Cloud Messaging (FCM) |
| Background Logic | Firebase Cloud Functions (Node.js) |
| Maps & Location | Google Maps Flutter Plugin + Geolocator |
| Geoqueries | GeoFlutterFire2 (Firestore geohash queries) |

---

## 3. User Roles

### 3.1 Customer
Creates task requests and awaits fulfillment.

### 3.2 Helper
Browses nearby tasks and fulfills them for payment.

### 3.3 Admin
Manages users, resolves disputes, monitors activity via a separate web panel (out of scope for this Flutter app — admin functions are handled via Firebase Console + Cloud Functions).

> **Role switching:** A user can be both a Customer and a Helper. The app should support role switching from the profile screen without requiring two separate accounts.

---

## 4. Firebase Data Models (Firestore Schema)

### 4.1 `users` Collection

```
users/{userId}
  - uid: String
  - fullName: String
  - phoneNumber: String (E.164 format, e.g. +923001234567)
  - profileImageUrl: String (Firebase Storage URL)
  - role: String ("customer" | "helper" | "both")
  - isHelperVerified: Boolean
  - cnicImageUrl: String (for helper verification — Firebase Storage)
  - averageRating: Double (default 0.0)
  - totalRatings: Integer (default 0)
  - totalTasksCompleted: Integer (default 0)
  - isActive: Boolean
  - isBanned: Boolean
  - fcmToken: String
  - createdAt: Timestamp
  - lastSeen: Timestamp
  - currentLocation: GeoPoint (updated periodically when helper is active)
  - geohash: String (computed from currentLocation for geo-queries)
```

### 4.2 `tasks` Collection

```
tasks/{taskId}
  - taskId: String
  - title: String
  - description: String
  - category: String (see Section 6)
  - estimatedItemCost: Double (PKR)
  - helperFee: Double (PKR — agreed compensation for the helper)
  - customerId: String (ref to users/{userId})
  - customerName: String
  - customerPhone: String
  - helperId: String? (null until accepted)
  - helperName: String?
  - helperPhone: String?
  - status: String (see Section 7)
  - pickupLocation: GeoPoint
  - pickupAddress: String
  - deliveryLocation: GeoPoint
  - deliveryAddress: String
  - geohash: String (computed from pickupLocation for nearby queries)
  - imageUrls: List<String> (optional photos of required items)
  - statusHistory: List<Map> (see Section 7.1)
  - createdAt: Timestamp
  - acceptedAt: Timestamp?
  - completedAt: Timestamp?
  - cancelledAt: Timestamp?
  - cancelReason: String?
  - cancelledBy: String? ("customer" | "helper")
  - rating: Integer? (1–5, set by customer after completion)
  - ratingComment: String?
  - isVisible: Boolean (false after completion or cancellation)
```

### 4.3 `ratings` Collection

```
ratings/{ratingId}
  - ratingId: String
  - taskId: String
  - customerId: String
  - helperId: String
  - score: Integer (1–5)
  - comment: String?
  - createdAt: Timestamp
```

### 4.4 `reports` Collection

```
reports/{reportId}
  - reportId: String
  - reportedBy: String (userId)
  - reportedUser: String (userId)
  - taskId: String?
  - reason: String
  - details: String?
  - status: String ("pending" | "reviewed" | "resolved")
  - createdAt: Timestamp
```

---

## 5. Authentication Flow

1. User enters Pakistani phone number (+92 format).
2. Firebase Auth sends OTP via SMS.
3. User enters OTP → Firebase verifies → creates or signs in user.
4. On **first login**, user is directed to the **onboarding/profile setup screen** to enter their name and optionally upload a profile photo.
5. On **subsequent logins**, user is directed to the home screen based on their last active role.

**Edge cases:**
- If OTP times out (60s), show a "Resend OTP" button.
- If phone number already exists in Firestore but auth record doesn't (data inconsistency), create auth record and link it.
- Banned users (`isBanned: true`) must see a "Your account has been suspended" screen and cannot proceed.

---

## 6. Task Categories

| Category ID | Display Name (English) | Display Name (Urdu) |
|-------------|----------------------|---------------------|
| `grocery` | Grocery Shopping | گروسری خریداری |
| `fruits_veg` | Fruits & Vegetables | پھل اور سبزیاں |
| `medicine` | Medicine Pickup | دوائی لانا |
| `parcel` | Parcel Pickup | پارسل اٹھانا |
| `document` | Document Delivery | دستاویز پہنچانا |
| `custom` | Custom Errand | کوئی اور کام |

---

## 7. Task Status Lifecycle

```
Posted → Accepted → Item Purchased → Delivery in Progress → Completed
                                                          ↘ Cancelled
```

| Status | Triggered By | Description |
|--------|-------------|-------------|
| `posted` | Customer | Task is live and visible to nearby helpers |
| `accepted` | Helper | Helper has claimed the task |
| `item_purchased` | Helper | Helper has bought/picked up the item |
| `delivery_in_progress` | Helper | Helper is en route to delivery location |
| `completed` | Customer | Customer confirms receipt |
| `cancelled` | Customer or Helper | Task was cancelled (see Section 7.2) |

### 7.1 Status History Array

Each status change appends an entry to `statusHistory`:
```json
{
  "status": "accepted",
  "updatedBy": "helperId",
  "timestamp": "Firestore Timestamp",
  "note": "Optional message"
}
```

### 7.2 Cancellation Rules

- **Customer** can cancel anytime before `item_purchased`.
- **Helper** can cancel anytime before `item_purchased`.
- After `item_purchased`, cancellation requires admin intervention (report flow).
- Cancellation increments a `cancellationCount` on the cancelling user's profile. Helpers with 3+ cancellations in 30 days get a warning flag.

---

## 8. Screen Inventory & UI Flows

### 8.1 Unauthenticated Screens

- **Splash Screen** — app logo, auto-navigate after 2s
- **Welcome Screen** — "I need help" (Customer) / "I want to help" (Helper) / "Both" options + Login CTA
- **Phone Entry Screen** — phone number input with +92 prefix
- **OTP Verification Screen** — 6-digit OTP input with 60s countdown + Resend button
- **Profile Setup Screen** (first-time only) — name, profile photo (optional)

### 8.2 Customer Screens

- **Customer Home** — active task card (if any) + "Post a Task" FAB + recent tasks list
- **Post Task Screen** — form: title, description, category picker, estimated cost, helper fee, pickup location (map picker), delivery location (map picker), optional image upload (max 3 photos)
- **Task Detail Screen (Customer View)** — full task info, current status, helper info (after acceptance), map showing helper location (during delivery), chat button, cancel button
- **Task Tracker Screen** — real-time status stepper (Posted → Accepted → Purchased → Delivering → Done)
- **Rate Helper Screen** — star rating (1–5) + optional comment (shown after helper marks delivery_in_progress and customer confirms)
- **My Tasks Screen** — filterable list of all past and active tasks
- **Profile Screen** — name, photo, phone, role switch toggle, logout

### 8.3 Helper Screens

- **Helper Home** — map view with nearby task pins + list view toggle
- **Task Browse Screen** — list of nearby `posted` tasks with distance, category badge, estimated cost, and helper fee
- **Task Detail Screen (Helper View)** — full task info, customer info, map with pickup + delivery pins, "Accept Task" button
- **Active Task Screen** — current task steps with action buttons: "Mark Item Purchased", "Mark Delivery Started", "Mark Delivered"
- **My Earnings Screen** — list of completed tasks with helper fees earned
- **Profile Screen** — same as Customer + CNIC verification upload section + toggle helper availability

### 8.4 Shared Screens

- **In-App Chat Screen** — per-task messaging between customer and helper (Firestore subcollection)
- **Notifications Screen** — list of past notifications
- **Report User Screen** — reason dropdown + description text field
- **Settings Screen** — language toggle (English/Urdu), notification preferences

---

## 9. Location & Geolocation Logic

### 9.1 Task Discovery (Helper Side)

- When a helper opens the app, fetch their current location via `Geolocator`.
- Query Firestore for tasks within **5 km radius** using GeoFlutterFire2 geohash queries.
- Filter results to only show `status == "posted"` tasks.
- Default radius: 5 km. Helper can adjust to 2 km, 5 km, 10 km via a slider.

### 9.2 Helper Location Tracking (During Active Task)

- When a helper has an `accepted` task, start a background location stream.
- Update `users/{helperId}.currentLocation` and `geohash` every **10 seconds**.
- Customer's task detail screen listens to this in real time and updates a map marker.
- Stop location updates when task reaches `completed` or `cancelled`.

### 9.3 Location Permissions

- Request `locationWhenInUse` on app start.
- If denied, show a dialog explaining why location is needed and link to settings.
- For background tracking (during active task), request `locationAlways` permission.

### 9.4 Map Pickers

- Task creation uses a Google Maps full-screen picker for both pickup and delivery addresses.
- Reverse geocoding converts the selected `GeoPoint` to a human-readable address string (stored in `pickupAddress` / `deliveryAddress`).

---

## 10. Notifications

All notifications use **Firebase Cloud Messaging (FCM)** triggered by **Cloud Functions**.

| Trigger | Recipient | Title | Body |
|---------|-----------|-------|------|
| Task posted within helper's radius | Nearby helpers | "New Task Nearby!" | "{taskTitle} — {distance} away" |
| Task accepted | Customer | "Helper Found!" | "{helperName} accepted your task" |
| Status → `item_purchased` | Customer | "Item Purchased" | "Your helper has bought the item" |
| Status → `delivery_in_progress` | Customer | "On the Way!" | "{helperName} is heading to you" |
| Task completed | Helper | "Task Complete!" | "Don't forget to collect payment" |
| New chat message | Other party | "New Message" | "{senderName}: {messagePreview}" |
| Task cancelled | Other party | "Task Cancelled" | "{cancelledBy} cancelled the task" |

FCM tokens are stored in `users/{userId}.fcmToken` and refreshed on each login.

---

## 11. In-App Chat

- Each task has a `chats/{taskId}/messages` Firestore subcollection.
- Messages structure:
```
chats/{taskId}/messages/{messageId}
  - senderId: String
  - senderName: String
  - text: String
  - timestamp: Timestamp
  - isRead: Boolean
```
- Chat is only accessible while the task is in `accepted`, `item_purchased`, or `delivery_in_progress` state.
- After `completed` or `cancelled`, chat becomes read-only.

---

## 12. Payment Model

Madadgar uses a **cash-on-delivery** model. There is no in-app payment processing.

**Flow:**
1. Customer sets `estimatedItemCost` (what the item costs) and `helperFee` (compensation for the helper).
2. Helper purchases the item using their own money.
3. On delivery, customer pays helper: `estimatedItemCost + helperFee` in cash.

**UI Clarity:**
- When posting a task, show two separate fields: "Item Cost (PKR)" and "Helper Fee (PKR)".
- Show a summary: "Total you'll pay on delivery: PKR {total}".
- On the helper's task card, prominently show the `helperFee` so they know their earnings upfront.

---

## 13. Helper Verification

Helpers must complete identity verification before they can accept tasks.

**Steps:**
1. Helper uploads front and back photo of CNIC (National ID) via Firebase Storage.
2. Status is set to `isHelperVerified: false` (pending review).
3. Admin reviews via Firebase Console (manual process for MVP).
4. Admin updates `isHelperVerified: true` via a Cloud Function or directly.
5. Helper receives a push notification: "Your account has been verified!"

**Enforcement:**
- Unverified helpers can browse tasks but cannot tap "Accept Task".
- Show a banner: "Complete verification to start accepting tasks" with a CTA.

---

## 14. Rating System

- Customers rate helpers on a 1–5 star scale after task completion.
- Rating is optional but prompted immediately after the helper marks delivery complete.
- `users/{helperId}.averageRating` is updated via a Cloud Function that recalculates the average whenever a new rating document is written to the `ratings` collection.
- Helpers with an average below 2.5 after 10+ ratings receive a review flag for admin.

---

## 15. Edge Cases & Error Handling

### Task Lifecycle Edge Cases

| Scenario | Handling |
|----------|---------|
| Helper accepts task but another helper already accepted it (race condition) | Use Firestore transaction on accept: check `status == "posted"` before writing. If status changed, show "This task was just taken. Browse other tasks." |
| Customer cancels after helper is already en route | If status is `item_purchased` or later, block cancellation and show "Contact the helper or submit a report" |
| Helper goes offline mid-task | Location updates stop; customer sees last known location. After 5 min inactivity, send helper a push: "Are you still on your way?" |
| Customer does not mark task complete after delivery | After 24 hours in `delivery_in_progress`, Cloud Function auto-completes the task and notifies both parties |
| Task posted but no helper accepts within 2 hours | Send customer a push: "No helper found yet. Consider increasing your helper fee." |
| App crashes/closes during task | On app relaunch, detect active task in Firestore and restore the active task screen |

### Auth Edge Cases

| Scenario | Handling |
|----------|---------|
| OTP not received | Show "Resend OTP" button after 60s countdown |
| Wrong OTP entered 3 times | Show "Too many attempts. Please try again in 10 minutes." (Firebase handles this natively) |
| User changes phone number | Not supported in MVP — direct to support |

### Network & Connectivity

- Use Flutter's `connectivity_plus` package to detect offline state.
- Show a persistent banner when offline: "No internet connection."
- Queue non-critical writes (e.g., chat messages) locally and sync when reconnected using Firestore's offline persistence (enabled by default).

---

## 16. Security Rules (Firestore)

```javascript
// Simplified summary of Firestore rules

// users: readable by authenticated users; writable only by owner
match /users/{userId} {
  allow read: if request.auth != null;
  allow write: if request.auth.uid == userId;
}

// tasks: readable by authenticated users; 
//        customer can create/update their own tasks;
//        helper can update status fields only
match /tasks/{taskId} {
  allow read: if request.auth != null;
  allow create: if request.auth.uid == resource.data.customerId;
  allow update: if request.auth.uid == resource.data.customerId
                || request.auth.uid == resource.data.helperId;
}

// chats: only task participants (customer + helper) can read/write
match /chats/{taskId}/messages/{messageId} {
  allow read, write: if request.auth.uid == get(/databases/$(database)/documents/tasks/$(taskId)).data.customerId
                     || request.auth.uid == get(/databases/$(database)/documents/tasks/$(taskId)).data.helperId;
}

// ratings: customer can create; anyone can read
match /ratings/{ratingId} {
  allow read: if request.auth != null;
  allow create: if request.auth.uid == resource.data.customerId;
}
```

---

## 17. Firebase Cloud Functions (Required)

| Function | Trigger | Logic |
|----------|---------|-------|
| `onTaskPosted` | Firestore onCreate `tasks/{taskId}` | Query nearby helpers within 5 km, send FCM notification to each |
| `onTaskStatusChanged` | Firestore onUpdate `tasks/{taskId}` | Send appropriate FCM notification based on new status value |
| `onNewMessage` | Firestore onCreate `chats/{taskId}/messages/{msgId}` | Send FCM notification to the other party in the task |
| `onRatingCreated` | Firestore onCreate `ratings/{ratingId}` | Recalculate and update `averageRating` and `totalRatings` on the helper's user document |
| `autoCompleteTask` | Cloud Scheduler (runs every hour) | Find tasks in `delivery_in_progress` for 24+ hours and auto-complete them |
| `flagLowRatedHelpers` | Firestore onUpdate `users/{userId}` | If `averageRating < 2.5` and `totalRatings >= 10`, set a `requiresReview: true` flag |

---

## 18. App Architecture (Flutter)

Use **Clean Architecture** with the following structure:

```
lib/
  core/
    constants/       # app colors, text styles, strings
    utils/           # formatters, validators, helpers
    widgets/         # shared reusable widgets
  features/
    auth/
      data/          # FirebaseAuthService
      domain/        # AuthRepository interface + use cases
      presentation/  # screens + controllers (Riverpod/BLoC)
    tasks/
      data/          # TaskFirestoreService
      domain/        # TaskRepository interface + use cases
      presentation/  # screens + controllers
    location/
      data/          # GeolocatorService, GeoFireService
      domain/        # LocationRepository
      presentation/  # map widgets
    chat/
      data/          # ChatFirestoreService
      presentation/  # ChatScreen
    profile/
      ...
  main.dart
```

**State Management:** Riverpod (preferred) or BLoC — choose one and be consistent throughout.

---

## 19. Localization

- Support **English** and **Urdu**.
- Use Flutter's `flutter_localizations` + `intl` package.
- Urdu text should use `Noto Nastaliq Urdu` font.
- Language toggle is available in Settings and persists via `SharedPreferences`.
- All user-facing strings must use localization keys — no hardcoded English strings.

---

## 20. MVP Scope vs. Future Features

### MVP (Build This First)

- Phone auth (OTP)
- Task posting (all categories)
- Nearby task discovery (geolocation)
- Task acceptance and status updates
- In-app chat
- Push notifications
- Cash payment model
- Ratings & reviews
- Helper CNIC verification (manual admin review)
- Basic report flow

### Post-MVP (Do Not Build Yet)

- In-app wallet / digital payment (JazzCash, EasyPaisa)
- Helper earnings dashboard with analytics
- Customer subscription plans
- Automated CNIC verification via OCR API
- Group tasks (multiple helpers on one task)
- Admin web panel (separate project)
- Referral system
- Task bidding (multiple helpers bid on one task)
