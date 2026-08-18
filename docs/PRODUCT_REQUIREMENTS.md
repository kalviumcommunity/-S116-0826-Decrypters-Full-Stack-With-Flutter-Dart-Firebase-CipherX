# CipherX — Product Requirements Document (PRD) 📋

> **Application Name**: CipherX  
> **Founding Team**: Team Decrypters (Hardik, Gauri, Avadhut)  
> **Document Version**: 1.0.0 (MVP Specification)  

---

## 1. Operational Context & Problem Statement

Private security service providers operate under a fundamental operational trust gap. Head offices assign hundreds of security guards daily across corporate campuses, gated residential complexes, warehouses, and commercial sites. However, operational execution flows through unstructured channels (phone calls, SMS, WhatsApp messages, paper sign-in sheets).

### Key Pain Points:
1. **Ghost Guarding & Attendance Spoofing**: Guards sign in for shifts remotely or have colleagues sign in on their behalf without physical presence at the site.
2. **Zero Real-Time Visibility**: Operations managers have no live view of site coverage, making it impossible to detect unstaffed posts before a security breach occurs.
3. **Delayed & Unverified Incident Reporting**: When incidents occur, reports are submitted hours later via informal text messages lacking exact geolocation, server timestamps, or verified photo evidence.
4. **Lack of Auditability**: Security agencies cannot produce immutable attendance or incident compliance reports during client contract audits or liability claims.

**CipherX** transforms security management from a passive, paper-based routine into a **verified, real-time security workforce platform**.

---

## 2. Core Operational Loop

CipherX strictly enforces an 10-stage closed operational loop across every guard shift:

```text
  ┌──────────┐      ┌──────────┐      ┌──────────┐      ┌──────────┐      ┌───────────┐
  │  ASSIGN  │ ───► │  SHIFT   │ ───► │  ARRIVE  │ ───► │  VERIFY  │ ───► │ CHECK-IN  │
  └──────────┘      └──────────┘      └──────────┘      └──────────┘      └───────────┘
                                                                                │
  ┌──────────┐      ┌──────────┐      ┌──────────┐      ┌──────────┐            │
  │  AUDIT   │ ◄─── │ RESOLVE  │ ◄─── │ INCIDENT │ ◄─── │  ALERT   │ ◄──────────┘
  └──────────┘      └──────────┘      └──────────┘      └──────────┘      MONITOR
```

| Phase | Description | Key Actors | System Trigger |
| :--- | :--- | :--- | :--- |
| **ASSIGN** | Head Office schedules a shift mapping a specific Guard to a Site with designated start/end times. | Admin / Supervisor | Shift document created in Firestore with status `scheduled`. |
| **SHIFT** | Guard receives real-time push notification and views shift details on mobile app. | Guard | Mobile app syncs assigned shift details. |
| **ARRIVE** | Guard physically arrives at designated client site premises. | Guard | Guard taps "Initiate Check-In" on mobile device. |
| **VERIFY** | App validates Guard identity, current device GPS location within site geofence radius, and scans site QR code. | Engine (Hardik) | Multi-factor verification quad-lock evaluated. |
| **CHECK-IN**| System commits verified attendance record with server timestamps and GPS coordinates. | Engine / Guard | Attendance document written; shift status transitions to `in_progress`. |
| **MONITOR**| Admin & Supervisor dashboards reflect live site coverage metrics and guard active status. | Admin / Supervisor | Real-time Firestore snapshot listeners update UI. |
| **ALERT** | System evaluates missed shift start times, late check-ins, or understaffed sites. | Alert System | Alert triggered and delivered to Supervisors via FCM. |
| **INCIDENT**| Guard logs on-site security anomalies with mandatory photo evidence compressed and uploaded. | Guard / Supervisor | Incident created with metadata in Firestore and photo in Firebase Storage. |
| **RESOLVE**| Supervisor/Admin reviews incident evidence, updates status, and logs resolution notes. | Supervisor / Admin | Incident status updated to `resolved`. |
| **AUDIT** | Append-only audit entry logged for compliance and client billing verification. | Audit Subsystem | Immutable entry created in `auditLogs` collection. |

---

## 3. Core Functional Requirements Matrix

### 3.1 Authentication & Multi-Tenant Access
- **Tenant Isolation**: All database queries and writes are partitioned by `organizationId`. Cross-tenant data leakage is prevented via Security Rules.
- **Role-Based Access Control (RBAC)**: Support for three distinct user roles: `admin`, `supervisor`, `guard`.
- **Session Persistence**: Secure persistent authentication tokens using Firebase Auth.

### 3.2 Site & Geofence Management
- Admin can create and update sites specifying Address, Latitude, Longitude, Geofence Radius (meters), and unique Site QR Code token.
- System dynamically generates QR codes for physical deployment at site entrances.

### 3.3 Shift Scheduling Engine
- Admin/Supervisor schedules shifts assigning a Guard to a Site for a specific date and time window.
- **Overlap & Conflict Prevention**: System rejects shift creation if a guard is assigned to overlapping time slots across any site.

### 3.4 Multi-Factor Attendance Verification Engine
- **Quad-Lock Verification**:
  1. User Authentication Check.
  2. Assigned Shift Window Validation (Current time within `startTime - 15 mins` to `startTime + 30 mins`).
  3. Geofence Distance Calculation (Haversine distance $\le$ site radius + GPS accuracy tolerance).
  4. Site QR Token Scan Matching.
- Server-authoritative timestamps (`FieldValue.serverTimestamp()`) prevent device clock manipulation.

### 3.5 Incident Reporting & Evidence Pipeline
- Guards can submit security incidents selecting Type (e.g. Theft, Vandalism, Trespassing, Equipment Failure, Medical) and Severity (`low`, `medium`, `high`, `critical`).
- Mandatory evidence upload: Compressed camera capture uploaded to Firebase Storage.

### 3.6 Real-Time Operations & Dashboard
- Operations team views live metrics: Total Guards, On-Duty Guards, Absent Guards, Late Check-Ins, Active Sites Coverage Percentage, Open Incidents.

---

## 4. Multi-Tenant Organization Model

```text
Organizations (Root Tenant)
├── Users (Admin, Supervisor, Guard)
├── Sites (Geofenced Client Locations)
├── Shifts (Scheduled Work Windows)
├── Attendance (Verified Check-in/Out Logs)
├── Incidents (On-site Security Events)
├── Alerts (System & Operational Thresholds)
└── AuditLogs (Immutable Event History)
```

---

## 5. Success Criteria & Operational KPIs

1. **Zero Unverified Check-Ins**: 100% of attendance logs backed by verified GPS coordinates and site QR token.
2. **Sub-Second Real-Time Dashboard Updates**: Dashboard metrics update live when guards check in or report incidents.
3. **Strict ₹0 Budget Execution**: Zero operational costs on free-tier Firebase services.
4. **Sub-15 Day Sprint Delivery**: Fully functional product shipped within 10–15 days by Team Decrypters.
