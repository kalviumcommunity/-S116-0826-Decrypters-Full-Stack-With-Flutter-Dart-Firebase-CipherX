# CipherX — 15-Day Sprint & Implementation Plan 📅

> **Application Name**: CipherX  
> **Founding Team**: Team Decrypters (Hardik, Gauri, Avadhut)  
> **Sprint Duration**: 15 Days (3 Parallel Workstreams)  
> **Document Version**: 1.0.0  

---

## 1. Team Parallel Workstream Distribution

```text
               ┌─────────────────────────────────────────────────────────┐
               │                     DAY 1 - DAY 15                      │
               └────┬───────────────────────┬───────────────────────┬────┘
                    │                       │                       │
                    ▼                       ▼                       ▼
         ┌───────────────────┐   ┌───────────────────┐   ┌───────────────────┐
         │      HARDIK       │   │       GAURI       │   │      AVADHUT      │
         │ (Lead / Backend / │   │ (Guard Experience │   │ (Admin / Ops /    │
         │  Rules / Engine)  │   │  & Mobile App)    │   │  Dashboard UI)    │
         └───────────────────┘   └───────────────────┘   └───────────────────┘
```

---

## 2. Day-by-Day Implementation Roadmap

### Phase 1: Foundation & Setup (Days 1–3)

#### **Day 1: Project Initialization & Architectural Foundation**
- **Hardik**: Configure Flutter 3.19 project with feature-first folder structure, Riverpod state scaffolding, GoRouter router initialization, and Firebase Emulator setup.
- **Gauri**: Create core Guard application UI components (glassmorphism card, status pills, custom app bar).
- **Avadhut**: Create core Admin application UI layout (sidebar, top navigation bar, metric card widgets).
- **Deliverable**: Bootable Flutter project connected to local Firebase Emulators.

#### **Day 2: Firebase Auth & Multi-Tenant Setup**
- **Hardik**: Implement Firebase Auth repository, custom claims parser, User domain entity, and AuthRiverpodNotifier. Write initial `users` Firestore security rules.
- **Gauri**: Build Guard Login Screen, error snackbars, and session loading states.
- **Avadhut**: Build Admin Login Screen and Tenant Setup Modal.
- **Deliverable**: Working authentication pipeline for Admin and Guard user accounts.

#### **Day 3: Navigation Guards & Role-Based Routing**
- **Hardik**: Implement GoRouter redirect guard pipeline (`appRouteRedirectGuard`) protecting `/admin/*`, `/supervisor/*`, and `/guard/*` routes.
- **Gauri**: Build Guard Home Shell layout (`/guard/today-shift`).
- **Avadhut**: Build Admin Shell layout (`/admin/dashboard`).
- **Deliverable**: Role-protected application shell.

---

### Phase 2: Core Domain & Management Features (Days 4–7)

#### **Day 4: Site & Geofence Management**
- **Hardik**: Write Firestore Security Rules for `sites/` collection and build `SiteRepository`.
- **Gauri**: Implement Site Location Map Preview component for guard shift details.
- **Avadhut**: Build Site Management UI (`CreateSiteModal`, `SiteListScreen`, Geofence radius slider).
- **Deliverable**: Full CRUD capabilities for geofenced client sites.

#### **Day 5: Guard Management & User Administration**
- **Hardik**: Implement Admin User Management repository and soft-delete user logic.
- **Gauri**: Build Guard Profile & Emergency Contact Screen.
- **Avadhut**: Build Guard Roster Management UI (`CreateGuardModal`, Guard list table, activation toggle).
- **Deliverable**: Admin interface to create and manage security guard profiles.

#### **Day 6: Shift Scheduling Engine (Part 1)**
- **Hardik**: Create `ShiftModel`, `ShiftRepository`, shift date/time range query methods, and shift conflict validation math.
- **Gauri**: Build Guard "Today's Shift" card widget displaying site address, shift timing, and supervisor phone link.
- **Avadhut**: Build Shift Calendar Roster UI for Admin/Supervisor (`ShiftSchedulerScreen`).
- **Deliverable**: Ability to schedule shifts and view assigned shifts on guard app.

#### **Day 7: Shift Scheduling Engine (Part 2)**
- **Hardik**: Implement multi-guard shift assignment logic and prevent double-booking shifts.
- **Gauri**: Build Guard Upcoming Shifts list view with date filtering.
- **Avadhut**: Build Shift Assignment Modal with guard selection dropdown and site mapping.
- **Deliverable**: Full operational shift assignment pipeline.

---

### Phase 3: Verification & Attendance Engine (Days 8–10)

#### **Day 8: Geofence Math & QR Code Integration**
- **Hardik**: Build `GeofenceCalculator` (Haversine formula), GPS accuracy filtering, and mock location detector.
- **Gauri**: Integrate `mobile_scanner` library and build native QR Code Scanner Widget for site check-in.
- **Avadhut**: Build Site QR Code Generator modal in Admin UI (downloads printable site QR plaques).
- **Deliverable**: Functioning QR code scanner and Haversine distance calculator.

#### **Day 9: Attendance Verification Engine Assembly**
- **Hardik**: Assemble `VerificationEngine` combining Auth + Shift Window + Haversine Distance + Site QR matching. Write `attendance/` Security Rules.
- **Gauri**: Build Guard Check-In & Check-Out Screen (`CheckInScreen`) with live GPS status indicator and verification steps.
- **Avadhut**: Build Live Attendance Feed widget in Admin Dashboard.
- **Deliverable**: Complete end-to-end verified check-in pipeline.

#### **Day 10: Attendance History & Exceptions**
- **Hardik**: Build attendance repository query filters and aggregate daily check-in logs.
- **Gauri**: Build Guard Attendance History Screen with date range picker.
- **Avadhut**: Build Admin Attendance Log Table with status filtering (`verified`, `flagged`, `missed`).
- **Deliverable**: Attendance history and exception tracking.

---

### Phase 4: Incidents, Alerts & Audit Trail (Days 11–13)

#### **Day 11: Incident Reporting & Evidence Pipeline**
- **Hardik**: Build `IncidentRepository`, image compression pipeline (`flutter_image_compress`), and Firebase Storage upload handler. Write `incidents/` Security Rules.
- **Gauri**: Build Create Incident Screen (`CreateIncidentScreen`) with camera photo capture, severity selector, and description fields.
- **Avadhut**: Build Incident Management Screen (`IncidentListScreen`, severity badge filters).
- **Deliverable**: Photo-evidenced incident creation pipeline.

#### **Day 12: Incident Resolution & Alert Engine**
- **Hardik**: Build `AlertAutomationService` interface, passive alert evaluator for overdue shifts, and FCM push notification payload handler.
- **Gauri**: Add FCM push alert receiver and in-app alert banner to Guard app.
- **Avadhut**: Build Incident Resolution Modal (add supervisor notes) and Real-Time Alerts Panel.
- **Deliverable**: Working alert detection and incident resolution workflow.

#### **Day 13: Operations Dashboard & Immutable Audit Log**
- **Hardik**: Build `AuditLoggerService`, write `auditLogs/` append-only Security Rules, and aggregate `dashboardStats` document writes.
- **Gauri**: Add audit log viewer to Guard profile (displays personal check-in audit history).
- **Avadhut**: Assemble main Operations Dashboard (`MetricsOverviewWidget`, live coverage percentage, understaffed site alerts, audit log viewer).
- **Deliverable**: Fully functioning operations dashboard and audit trail.

---

### Phase 5: Testing, Hardening & Final Review (Days 14–15)

#### **Day 14: Security Auditing & Edge Case Testing**
- **Hardik**: Conduct penetration testing against Firestore Security Rules (attempt cross-tenant access, unauthorized writes, clock tampering).
- **Gauri**: Test Guard app under offline mode, weak GPS signal, camera permission denied, and invalid QR codes.
- **Avadhut**: Test Admin Dashboard with 50+ simulated shifts, multi-site filtering, and heavy data stress test.
- **Deliverable**: Verified security rules and edge-case resilient application.

#### **Day 15: Final Demo Preparation & Polish**
- **Hardik**: Final code refactoring, complete documentation review, build production APK/Web bundles.
- **Gauri**: UI polish, micro-animations, loading shimmers, and error snackbar styling.
- **Avadhut**: Dashboard chart styling, report export styling, and final presentation demo walkthrough.
- **Deliverable**: Production-ready **CipherX MVP** release.
