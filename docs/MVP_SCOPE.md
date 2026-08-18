# CipherX — MVP Scope Control & Feature Boundaries 🎯

> **Application Name**: CipherX  
> **Founding Team**: Team Decrypters (Hardik, Gauri, Avadhut)  
> **Document Version**: 1.0.0  

---

## 1. Scope Control Philosophy

To deliver a production-grade security operations platform within a **10–15 day sprint** under a **₹0 budget**, scope boundaries must be strictly enforced.

```text
┌────────────────────────────────────────────────────────────────────────┐
│                          CIPHERX SCOPE MATRIX                          │
├──────────────────────────┬───────────────────────┬─────────────────────┤
│ MUST HAVE (15-Day MVP)   │ SHOULD HAVE (Post-MVP)│ FUTURE (V2 Release) │
├──────────────────────────┼───────────────────────┼─────────────────────┤
│ Auth & RBAC              │ CSV / PDF Export      │ AI Guard Face ID    │
│ Multi-Tenant Org Model   │ Advanced Filters      │ AI Incident Classify│
│ Guard & Site Management  │ Offline Sync Queue    │ Continuous Live GPS │
│ Shift Scheduling         │ Supervisor Live Chat  │ Payroll Integration │
│ Quad-Lock Check-In       │ Shift Swap Requests   │ Predictive Absence  │
│ Photo Evidence Upload    │ Client Portal         │ Bodycam Streaming   │
│ Real-Time Alerts         │ Custom Branding       │ Voice Call Intercom │
│ Operations Dashboard     │ Multi-Language (i18n) │ Shift Auto-Optimizer│
│ Immutable Audit Logs     │ Guard Rating System   │ Bluetooth Beacons   │
└──────────────────────────┴───────────────────────┴─────────────────────┘
```

---

## 2. Granular Scope Specifications

### 2.1 MUST HAVE (Non-Negotiable MVP Scope)
Every item in this list MUST be fully implemented, tested, and integrated by Day 15:

1. **Authentication & Roles**: Firebase Auth login/logout, session persistence, role detection (`admin`, `supervisor`, `guard`), route protection.
2. **Organization Tenant Model**: Complete data isolation using `organizationId`.
3. **Guard Management**: Create guard profiles, update guard details, employee ID assignment, activate/deactivate accounts.
4. **Site & Geofence Management**: Create client sites with address, latitude, longitude, configurable geofence radius, and site QR code generation.
5. **Shift Roster Management**: Schedule shifts mapping Guard to Site, start/end time windows, shift status tracking, and conflict prevention.
6. **Quad-Lock Verification Engine**:
   - Auth check
   - Shift window check (15m before to 30m after start)
   - Haversine geofence distance check ($\le$ site radius + accuracy tolerance)
   - Site QR payload scan verification
7. **Attendance Logging**: Server-timestamped check-in and check-out records storing GPS coordinates and verification method.
8. **Incident Reporting & Evidence**: Create incident reports with severity classification (`low`, `medium`, `high`, `critical`), description, and mandatory compressed photo evidence upload to Firebase Storage.
9. **Operational Alerting**: Trigger alerts for missed shifts, late check-ins, understaffed sites, and critical incidents; FCM push notification delivery.
10. **Operations Dashboard**: Admin metrics showing total guards, active guards on duty, absent/late guards, site coverage percentage, open incidents, and critical alerts.
11. **Immutable Audit Trail**: Append-only log of operational changes (`USER_CREATED`, `SHIFT_CREATED`, `CHECK_IN_SUCCESS`, `INCIDENT_RESOLVED`).

---

### 2.2 SHOULD HAVE (Phase 2 - Post-MVP Enhancements)
Features to be added immediately after the 15-day sprint once MUST HAVE functionality is stable:

1. **Export Operations Reports**: Generate PDF/CSV attendance and incident reports for client billing.
2. **Advanced Filtering**: Filter shift calendar by guard name, site location, or shift status.
3. **Offline Queue Sync**: Local SQLite cache to queue check-ins offline and auto-sync when cellular signal returns.
4. **Shift Swap Requests**: Allow guards to request shift swaps subject to supervisor approval.
5. **Multi-Language (i18n)**: English + Hindi mobile app localization for guard user accessibility.

---

### 2.3 FUTURE (V2 & Enterprise Vision — Out of Scope for MVP)
> [!CAUTION]
> **Strict Prohibition**: Developers must NOT spend time implementing any FUTURE feature during the 15-day MVP sprint.

1. **AI Face Verification**: Facial recognition during check-in (requires paid ML API infrastructure).
2. **AI Automated Incident Classification**: Natural language processing on incident descriptions.
3. **Continuous Background GPS Tracking**: Battery-heavy live tracking (violates privacy principles & free-tier limits).
4. **Predictive Absenteeism ML Models**: Machine learning models predicting guard no-shows based on historical weather and traffic.
5. **Payroll & Compensation Integration**: Direct integration with Stripe or Razorpay.
6. **Video & Voice Intercom**: Live WebRTC video calling between guards and head office.
7. **Bluetooth BLE Beacon Verification**: Hardware beacon scanning for indoor indoor positioning.
