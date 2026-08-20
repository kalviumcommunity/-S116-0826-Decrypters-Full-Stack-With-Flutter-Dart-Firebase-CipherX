# Cipher-X — 10-Day Development Plan 📅

> **Application Name**: Cipher-X  
> **Founding Team**: Team Decrypters (Hardik, Gauri, Avadhut)  
> **Sprint Duration**: 10 Days (~40 PR Target)  
> **Document Version**: 1.0.0  

---

## 1. Team Parallel Workstream Distribution

```text
               ┌─────────────────────────────────────────────────────────┐
               │                     DAY 1 - DAY 10                      │
               └────┬───────────────────────┬───────────────────────┬────┘
                    │                       │                       │
                    ▼                       ▼                       ▼
         ┌───────────────────┐   ┌───────────────────┐   ┌───────────────────┐
         │      HARDIK       │   │       GAURI       │   │      AVADHUT      │
         │ (Tech Lead / Core │   │ (Guard Mobile App │   │ (Admin Operations │
         │ Architecture/Rules)│   │  & Guard UX)      │   │  & Dashboard UI)  │
         └───────────────────┘   └───────────────────┘   └───────────────────┘
```

### Team Member Ownership Matrix:

- **Hardik**: Architecture, Firebase, Auth, RBAC, Core domain, Firestore, Attendance engine, Geofence engine, Security rules, Alert architecture, Integration, Code review, Release.
- **Gauri**: Guard app, Guard dashboard, Shift UI, GPS, QR, Check-in, Check-out, Incident reporting, Evidence upload, Guard UX.
- **Avadhut**: Admin dashboard, Guard management, Site management, Shift management UI, Coverage dashboard, Incident management, Alert UI, QA support, Demo data.

---

## 2. 10-Day Implementation Roadmap

### **Day 1: Phase 0 + Foundation**
- **Hardik**: Finalize Phase 0 documentation contract (PRs #1–#4). Initialize Flutter codebase with feature-first folder structure, Riverpod providers, GoRouter initialization, and Firebase Emulator configuration.
- **Gauri**: Build base Guard UI design system tokens, themes, app bar, status pills, and empty state widgets.
- **Avadhut**: Build base Admin Dashboard shell, navigation sidebar, top header, and summary card widgets.
- **Deliverable**: Phase 0 locked contract and bootable Flutter foundation connected to Firebase Emulators.

### **Day 2: Authentication + RBAC**
- **Hardik**: Implement Firebase Auth repository, custom claims parser, User domain entity, and `AuthRiverpodNotifier`. Write `users/` collection Security Rules and GoRouter redirect guards.
- **Gauri**: Build Guard Login Screen, error handling snackbars, and authentication state listeners.
- **Avadhut**: Build Admin Login Screen, Organization Tenant Setup UI, and user session controls.
- **Deliverable**: Full multi-tenant authentication pipeline with role-based routing (`admin`, `supervisor`, `guard`).

### **Day 3: Guards + Sites**
- **Hardik**: Implement `SiteRepository` and Guard User Management services. Write `sites/` collection Security Rules with tenant isolation.
- **Gauri**: Build Guard Profile Screen, emergency contact UI, and site location map view.
- **Avadhut**: Build Site Management UI (`CreateSiteModal`, site list, geofence radius slider) and Guard Roster Management UI.
- **Deliverable**: Full CRUD operations for security guards and geofenced client sites.

### **Day 4: Shift Management**
- **Hardik**: Implement `ShiftModel`, `ShiftRepository`, shift date/time range query methods, shift conflict validation logic, and write `shifts/` Security Rules.
- **Gauri**: Build Guard "Today's Shift" card widget displaying site address, shift timing, and supervisor contact link.
- **Avadhut**: Build Admin Shift Scheduler UI (`ShiftCalendarView`, shift creation modal, guard assignment dropdown).
- **Deliverable**: Complete shift scheduling pipeline preventing double-booking.

### **Day 5: GPS + Geofence**
- **Hardik**: Implement `GeofenceCalculator` (Haversine formula), GPS accuracy filtering, mock location detection, and location permission handler.
- **Gauri**: Build Guard GPS status indicator and site proximity feedback widget.
- **Avadhut**: Add geofence coverage preview map to Site Management admin UI.
- **Deliverable**: Validated GPS location and Haversine distance engine.

### **Day 6: QR + Attendance**
- **Hardik**: Assemble `VerificationEngine` combining Auth + Shift Window + Haversine Distance + Site QR matching. Write `attendance/` Security Rules.
- **Gauri**: Integrate `mobile_scanner` and build native QR Code Scanner Widget & Check-In/Out UI.
- **Avadhut**: Build Site QR Code Generator (download printable site QR plaques) and live attendance feed.
- **Deliverable**: Quad-lock verified attendance check-in & check-out pipeline.

### **Day 7: Incidents + Alerts**
- **Hardik**: Build `IncidentRepository`, image compression pipeline (`flutter_image_compress`), Firebase Storage evidence uploader, passive alert evaluator, and write `incidents/` Security Rules.
- **Gauri**: Build Incident Submission Screen with camera photo capture, severity picker, and description fields. Add FCM alert receiver.
- **Avadhut**: Build Incident Management Screen, photo evidence modal, incident status resolver, and Real-Time Alerts Panel.
- **Deliverable**: Photo-evidenced incident workflow and real-time alert system.

### **Day 8: Command Center**
- **Hardik**: Build `AuditLoggerService`, write append-only `auditLogs/` Security Rules, and aggregate `dashboardStats` document writes.
- **Gauri**: Build Guard Attendance History Screen with date filtering and personal audit logs.
- **Avadhut**: Assemble main Command Center Operations Dashboard (total guards, active on duty, absent/late metrics, site coverage percentage, critical alert feed).
- **Deliverable**: Live Command Center Dashboard and immutable audit trail.

### **Day 9: Security + QA**
- **Hardik**: Perform security penetration audit against Firestore Security Rules (test cross-tenant access, unauthorized writes, clock tampering).
- **Gauri**: Conduct edge-case testing for Guard app (no internet/offline cache, weak GPS signal, camera permission denied, invalid QR).
- **Avadhut**: Perform stress testing on Admin Dashboard with 50+ simulated shifts and multi-site filters. Create demo seed dataset.
- **Deliverable**: Hardened application passing all security tests and edge cases.

### **Day 10: Production + Release**
- **Hardik**: Conduct final code review, verify zero paid dependencies, assemble production release artifacts (Android APK & Web build).
- **Gauri**: Perform UI polish, micro-animations, loading shimmers, and error state verification.
- **Avadhut**: Verify operational walkthrough, dashboard analytics styling, and final demo readiness.
- **Deliverable**: Production-ready **Cipher-X MVP** release.
