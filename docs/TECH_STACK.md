# CipherX — Tech Stack & Free-Tier Budget Specifications 🛠️

> **Application Name**: CipherX  
> **Founding Team**: Team Decrypters (Hardik, Gauri, Avadhut)  
> **Document Version**: 1.0.0  

---

## 1. Non-Negotiable Budget & Tech Constraints

CipherX is strictly engineered for **₹0 development budget, ₹0 hosting budget, and ₹0 paid backend dependencies**.

### Non-Negotiable Stack Rules:
- ❌ **NO Paid Cloud Functions**: Mandatory Cloud Functions (which require the paid Firebase Blaze plan) are prohibited.
- ❌ **NO Custom Node.js / Express Servers**: Eliminates backend hosting costs (Heroku, AWS EC2, DigitalOcean).
- ❌ **NO Relational Databases or Docker**: Eliminates PostgreSQL, MySQL, Redis, and container hosting expenses.
- ✅ **100% Client-Side + Serverless Firebase Free Tier**: Leveraging Firebase Auth, Cloud Firestore, Firebase Storage, and FCM on the free **Spark Plan**.

---

## 2. Technology Stack Selection Rationale

| Category | Chosen Technology | Exact Version / Package | Rationale |
| :--- | :--- | :--- | :--- |
| **Framework** | Flutter | `3.19.x` (Dart `3.3.x`) | Single cross-platform codebase targets Android/iOS (Guard Mobile) & Web (Admin Dashboard). |
| **State Management** | Flutter Riverpod | `flutter_riverpod: ^2.5.1` | Compile-time safety, seamless async state handling, zero static context dependencies. |
| **Routing** | GoRouter | `go_router: ^13.2.0` | Declarative, URL-driven routing with built-in redirection guards for RBAC protection. |
| **Data Immutability** | Freezed + Codegen | `freezed: ^2.4.7`<br>`json_serializable: ^6.7.1` | Generates immutable domain models, value equality, and JSON serialization. |
| **Authentication** | Firebase Auth | `firebase_auth: ^4.17.8` | Handles user authentication, token refresh, session persistence, and custom claims. |
| **Database** | Cloud Firestore | `cloud_firestore: ^4.15.8` | Real-time NoSQL database with document listeners, offline persistence, and Security Rules. |
| **File Storage** | Firebase Storage | `firebase_storage: ^11.6.9` | Blob storage for incident photo evidence with strict path-based Security Rules. |
| **Push Alerts** | Firebase Messaging | `firebase_messaging: ^14.7.19` | Cloud notification delivery to guard mobile devices for shift assignments & alerts. |
| **App Security** | Firebase App Check | `firebase_app_check: ^0.2.1+17` | Validates client integrity and blocks unauthorized API calls. |
| **Geolocation** | Geolocator | `geolocator: ^11.0.0` | Provides accurate GPS coordinate capture, location accuracy checks, and distance math. |
| **QR Code Scanner** | Mobile Scanner | `mobile_scanner: ^5.0.0` | Native camera QR code scanner widget for site verification. |
| **Image Compression**| Flutter Image Compress | `flutter_image_compress: ^2.1.8` | Compresses captured incident images on-device before Firebase Storage upload. |

---

## 3. Firebase Free Tier (Spark Plan) Budget Allocation

CipherX operates well within the generous monthly free allowances provided by Firebase:

```text
┌────────────────────────────────────────────────────────────────────────┐
│                        FIREBASE FREE SPARK LIMITS                      │
├───────────────────────┬──────────────────────┬─────────────────────────┤
│ Resource              │ Spark Plan Allowance │ Estimated CipherX Usage │
├───────────────────────┼──────────────────────┼─────────────────────────┤
│ Firestore Reads       │ 50,000 / day         │ ~5,000 / day            │
│ Firestore Writes      │ 20,000 / day         │ ~1,200 / day            │
│ Firestore Storage     │ 1 GB total           │ ~50 MB total            │
│ Storage Uploads       │ 20,000 / day         │ ~300 / day              │
│ Storage Download Band │ 1 GB / day           │ ~50 MB / day            │
│ Authentication        │ 10,000 / month       │ ~100 active accounts    │
│ FCM Notifications     │ Unlimited (Free)     │ ~500 / day              │
└───────────────────────┴──────────────────────┴─────────────────────────┘
```

---

## 4. Free-Tier Replacement Strategy for Cloud Functions

Commercial platforms often rely on scheduled Cloud Functions for cron triggers (e.g. marking shifts as `missed` if check-in hasn't occurred 30 minutes after start time). To maintain ₹0 cost, CipherX employs a **Passive Automation Architecture**:

### Free-Tier Automation Matrix:

```text
┌─────────────────────────┬───────────────────────────────┬──────────────────────────────────────────┐
│ Feature                 │ Standard Paid Solution        │ CipherX Free-Tier Solution               │
├─────────────────────────┼───────────────────────────────┼──────────────────────────────────────────┤
│ Missed Shift Detection  │ Cloud Scheduler + Cloud Func  │ Client-Side Evaluator on Admin Dashboard │
│                         │                               │ + Free GitHub Actions Scheduled Workflow │
├─────────────────────────┼───────────────────────────────┼──────────────────────────────────────────┤
│ Late Check-In Alerts    │ Firestore Trigger Function    │ Real-time Firestore query filter         │
│                         │                               │ evaluated on Supervisor App launch       │
├─────────────────────────┼───────────────────────────────┼──────────────────────────────────────────┤
│ Dashboard Stats Aggreg  │ Scheduled Aggregator Function │ Cached `dashboardStats` document updated │
│                         │                               │ atomically during check-in write         │
└─────────────────────────┴───────────────────────────────┴──────────────────────────────────────────┘
```

1. **Client-Side Evaluator Pattern**: When an Admin or Supervisor opens their dashboard, the app executes a fast indexed query for past-due shifts with status `scheduled` and updates their status to `missed` with zero server infrastructure.
2. **GitHub Actions Cron Runner (Optional Zero-Cost Trigger)**: A free GitHub Action scheduled workflow runs every 15 minutes, triggering a lightweight Dart script that evaluates overdue shifts via Firebase Admin SDK.

---

## 5. Local Emulator Suite Workflow

All developers (Hardik, Gauri, Avadhut) test locally using the **Firebase Emulator Suite** without touching live production databases or incurring accidental costs.

### Emulator Config (`firebase.json`):
```json
{
  "emulators": {
    "auth": {
      "port": 9099
    },
    "firestore": {
      "port": 8080
    },
    "storage": {
      "port": 9199
    },
    "ui": {
      "enabled": true,
      "port": 4000
    }
  }
}
```

### Launching Local Environment:
```bash
firebase emulators:start --only auth,firestore,storage
```
