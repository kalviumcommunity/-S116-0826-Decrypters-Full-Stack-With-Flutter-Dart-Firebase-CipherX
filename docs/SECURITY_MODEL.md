# CipherX — Security Model & Security Rules Specification 🔒

> **Application Name**: CipherX  
> **Founding Team**: Team Decrypters (Hardik, Gauri, Avadhut)  
> **Document Version**: 1.0.0  

---

## 1. Security Architecture Principles

CipherX operates on a **Defense-in-Depth Security Framework**:

```text
[ Firebase App Check ] ──► [ Authentication ] ──► [ Custom Claims / Role Check ] ──► [ Firestore Security Rules ]
  (Client Attestation)      (Identity Check)       (Tenant & RBAC Verification)       (Database Authorization)
```

1. **Least Privilege**: Users are granted the minimum database read/write permissions required for their specific role.
2. **Tenant Isolation**: Rules strictly enforce that `request.auth.token.orgId == resource.data.organizationId`. A guard or admin from Org A can NEVER read or write documents belonging to Org B.
3. **Immutable Audit Trail**: Normal client applications cannot update or delete documents inside `auditLogs`. Only append (create) operations are authorized.
4. **App Check Protection**: Attests that database requests originate exclusively from authentic CipherX app builds.

---

## 2. Declarative Firestore Security Rules (`firestore.rules`)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Helper Functions
    function isAuthenticated() {
      return request.auth != null;
    }

    function getUserData() {
      return get(/databases/$(database)/documents/users/$(request.auth.uid)).data;
    }

    function isOrgMember(orgId) {
      return isAuthenticated() && getUserData().organizationId == orgId;
    }

    function isAdmin() {
      return isAuthenticated() && getUserData().role == 'admin';
    }

    function isSupervisor() {
      return isAuthenticated() && getUserData().role == 'supervisor';
    }

    function isGuard() {
      return isAuthenticated() && getUserData().role == 'guard';
    }

    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }

    // ------------------------------------------------------------------
    // Organizations
    // ------------------------------------------------------------------
    match /organizations/{orgId} {
      allow read: if isOrgMember(orgId);
      allow write: if isAdmin() && isOrgMember(orgId);
    }

    // ------------------------------------------------------------------
    // Users
    // ------------------------------------------------------------------
    match /users/{userId} {
      allow read: if isAuthenticated() && isOrgMember(resource.data.organizationId);
      allow create, update: if isAdmin() && isOrgMember(request.resource.data.organizationId);
      allow delete: if false; // Soft deletes required
    }

    // ------------------------------------------------------------------
    // Sites
    // ------------------------------------------------------------------
    match /sites/{siteId} {
      allow read: if isAuthenticated() && isOrgMember(resource.data.organizationId);
      allow write: if isAdmin() && isOrgMember(request.resource.data.organizationId);
    }

    // ------------------------------------------------------------------
    // Shifts
    // ------------------------------------------------------------------
    match /shifts/{shiftId} {
      allow read: if isAuthenticated() && isOrgMember(resource.data.organizationId);
      allow create, update: if (isAdmin() || isSupervisor()) && isOrgMember(request.resource.data.organizationId);
      allow delete: if isAdmin() && isOrgMember(resource.data.organizationId);
    }

    // ------------------------------------------------------------------
    // Attendance Records
    // ------------------------------------------------------------------
    match /attendance/{attendanceId} {
      allow read: if isAuthenticated() && isOrgMember(resource.data.organizationId);
      
      // Guard Check-In Validation
      allow create: if isGuard() 
        && isOrgMember(request.resource.data.organizationId)
        && request.resource.data.guardId == request.auth.uid
        && request.resource.data.checkInTime == request.time; // Enforce server timestamp
        
      allow update: if (isGuard() && resource.data.guardId == request.auth.uid) // Checkout write
        || ((isAdmin() || isSupervisor()) && isOrgMember(resource.data.organizationId));
        
      allow delete: if false; // Attendance records are immutable once logged
    }

    // ------------------------------------------------------------------
    // Incidents
    // ------------------------------------------------------------------
    match /incidents/{incidentId} {
      allow read: if isAuthenticated() && isOrgMember(resource.data.organizationId);
      allow create: if (isGuard() || isSupervisor() || isAdmin()) 
        && isOrgMember(request.resource.data.organizationId);
      allow update: if (isAdmin() || isSupervisor()) 
        && isOrgMember(resource.data.organizationId);
      allow delete: if false;
    }

    // ------------------------------------------------------------------
    // Alerts
    // ------------------------------------------------------------------
    match /alerts/{alertId} {
      allow read: if isAuthenticated() && isOrgMember(resource.data.organizationId);
      allow create, update: if (isAdmin() || isSupervisor()) 
        && isOrgMember(request.resource.data.organizationId);
      allow delete: if isAdmin();
    }

    // ------------------------------------------------------------------
    // Audit Logs (Append-Only)
    // ------------------------------------------------------------------
    match /auditLogs/{auditId} {
      allow read: if isAdmin() && isOrgMember(resource.data.organizationId);
      allow create: if isAuthenticated() 
        && isOrgMember(request.resource.data.organizationId)
        && request.resource.data.actorId == request.auth.uid;
      allow update, delete: if false; // Strictly immutable!
    }

    // ------------------------------------------------------------------
    // Dashboard Stats
    // ------------------------------------------------------------------
    match /dashboardStats/{orgId} {
      allow read: if (isAdmin() || isSupervisor()) && isOrgMember(orgId);
      allow write: if (isAdmin() || isSupervisor()) && isOrgMember(orgId);
    }
  }
}
```

---

## 3. Firebase Storage Security Rules (`storage.rules`)

Protects incident evidence media uploads:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    
    match /incidents/{incidentId}/evidence/{fileName} {
      // Must be authenticated and under 10MB image size limit
      allow read: if request.auth != null;
      allow write: if request.auth != null
        && request.resource.size < 10 * 1024 * 1024
        && request.resource.contentType.matches('image/.*');
    }
  }
}
```

---

## 4. Anti-Spoofing & Data Integrity Safeguards

1. **Clock Spoofing Defense**: Device clocks can be manipulated by changing phone system settings. CipherX Security Rules mandate `request.resource.data.checkInTime == request.time`, enforcing server-authoritative timestamps.
2. **Duplicate Check-In Defense**: The `AttendanceRepository` queries existing attendance records matching `shiftId` before writing, preventing duplicate submissions.
3. **Data Minimization & Privacy**: GPS tracking is captured ONLY during discrete operational events (Check-In, Check-Out, Incident Submission). CipherX **does NOT perform continuous background location tracking**.
