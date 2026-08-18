# CipherX — User Roles & Role-Based Access Control (RBAC) 👥

> **Application Name**: CipherX  
> **Founding Team**: Team Decrypters (Hardik, Gauri, Avadhut)  
> **Document Version**: 1.0.0  

---

## 1. Role Definitions & Hierarchy

CipherX supports three explicit user roles. Access control is strictly enforced at both the **UI Route Guard Layer** (GoRouter) and the **Database Security Layer** (Firestore Security Rules).

```text
               ┌───────────────────────────┐
               │           ADMIN           │
               │   (Head Office Executive) │
               └─────────────┬─────────────┘
                             │
                             ▼
               ┌───────────────────────────┐
               │        SUPERVISOR         │
               │  (Field Area Operations)  │
               └─────────────┬─────────────┘
                             │
                             ▼
               ┌───────────────────────────┐
               │           GUARD           │
               │    (On-Site Security)     │
               └───────────────────────────┘
```

---

## 2. Granular Role Capabilities

### 2.1 ADMIN (Head Office Operations)
- **Organization Control**: Full administrative management of the agency tenant.
- **Guard Management**: Create, update, activate, or deactivate guard user profiles and assign employee IDs.
- **Site & Geofence Management**: Create/update client sites, define geofence boundaries (latitude, longitude, radius), and generate site QR codes.
- **Shift Rostering**: Schedule, assign, update, or cancel shifts across all organization sites.
- **Full Operational Visibility**: Access live dashboard showing total coverage, active incidents, attendance metrics, and audit logs.
- **Incident Resolution**: Review, reclassify, or resolve high-severity incidents.

### 2.2 SUPERVISOR (Field Operations Lead)
- **Assigned Site Monitoring**: View assigned sites and guards under their area command.
- **Roster View**: View scheduled shifts for assigned sites.
- **Live Coverage View**: Monitor guard check-in status and late alerts in real time.
- **Incident Review**: Inspect incident reports submitted by guards and add supervisory resolution notes.
- **Operational Exceptions**: Flag missed check-ins and initiate manual check-in override requests.

### 2.3 GUARD (On-Site Security Personnel)
- **Authentication**: Login/logout and manage basic profile settings.
- **Today's Roster**: View today's assigned shift details (site address, start/end time, supervisor contact).
- **Multi-Factor Verification**: Execute Check-In / Check-Out via GPS + Geofence + Site QR Code scanning.
- **Incident Reporting**: Submit on-site security incident reports with mandatory camera evidence upload.
- **Attendance History**: View historical personal attendance records.
- ❌ **Forbidden**: Cannot view other guards' private records, modify shift rosters, alter attendance timestamps, or access admin metrics.

---

## 3. RBAC Permission Matrix

| Operational Action | Admin | Supervisor | Guard | Security Rule Validation |
| :--- | :---: | :---: | :---: | :--- |
| **Manage Organization Settings** | ✅ | ❌ | ❌ | `request.auth.token.role == 'admin'` |
| **Create / Deactivate Guard Accounts** | ✅ | ❌ | ❌ | Admin role check |
| **Create / Update Client Sites** | ✅ | ❌ | ❌ | Admin role check |
| **Create / Assign Shifts** | ✅ | ✅ | ❌ | Admin or Supervisor role check |
| **Perform Check-In / Check-Out** | ❌ | ❌ | ✅ | Guard matching shift target |
| **View Own Assigned Shifts** | ✅ | ✅ | ✅ | Document `guardId == request.auth.uid` |
| **Submit Incident Report** | ❌ | ✅ | ✅ | Guard or Supervisor on active shift |
| **Resolve Incident** | ✅ | ✅ | ❌ | Admin or Supervisor role check |
| **View Organization Audit Logs** | ✅ | ❌ | ❌ | Admin role check |
| **View Overall Dashboard Metrics** | ✅ | ✅ | ❌ | Admin or Supervisor role check |

---

## 4. Authentication & Custom Claims Structure

User roles are embedded in two locations for double validation:

1. **Firebase Auth Custom Claims**: Attached to the Auth ID Token for fast routing without extra database reads:
   ```json
   {
     "orgId": "org_decrypters_001",
     "role": "admin"
   }
   ```
2. **Firestore User Document (`users/{userId}`)**:
   ```json
   {
     "uid": "usr_guard_101",
     "organizationId": "org_decrypters_001",
     "role": "guard",
     "employeeId": "EMP-8849",
     "fullName": "Rajesh Kumar",
     "phoneNumber": "+919876543210",
     "isActive": true,
     "createdAt": "2026-08-19T00:00:00Z"
   }
   ```

---

## 5. UI Routing & Navigation Protection Flow

```dart
// GoRouter Redirect Guard Implementation
String? appRouteRedirectGuard(BuildContext context, GoRouterState state) {
  final authState = ref.read(authProvider);
  
  if (!authState.isAuthenticated) {
    return state.matchedLocation == '/login' ? null : '/login';
  }
  
  final role = authState.userRole;
  final path = state.matchedLocation;
  
  if (path.startsWith('/admin') && role != UserRole.admin) {
    return '/unauthorized';
  }
  
  if (path.startsWith('/guard') && role != UserRole.guard) {
    return '/unauthorized';
  }
  
  return null;
}
```
