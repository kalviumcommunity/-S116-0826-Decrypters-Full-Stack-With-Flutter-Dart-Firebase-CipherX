# CipherX — Firestore Data Schema & Query Index Specification 🗄️

> **Application Name**: CipherX  
> **Founding Team**: Team Decrypters (Hardik, Gauri, Avadhut)  
> **Document Version**: 1.0.0  

---

## 1. Multi-Tenant Architecture & Data Principles

CipherX uses a top-level collections model with mandatory **tenant isolation** via `organizationId`. Every operational document must contain `organizationId` to ensure zero cross-tenant data leakage.

### Core Data Principles:
- **Server Timestamps**: All creation and modification timestamps use `FieldValue.serverTimestamp()` to prevent client clock tampering.
- **Soft Deletion**: Entities like `users` and `sites` are never deleted hard from Firestore; they set `isActive: false` or `isDeleted: true` to preserve attendance audit integrity.
- **Controlled Denormalization**: Denormalize essential display labels (e.g. `guardName`, `siteName`) inside `shifts` and `attendance` documents to eliminate expensive join reads.

---

## 2. Collection Schemas

### 2.1 Collection: `organizations`
> Path: `organizations/{organizationId}`

```typescript
interface Organization {
  id: string;                    // Organization ID (e.g., "org_decrypters_001")
  name: string;                  // Agency Name (e.g., "Apex Security Services")
  contactEmail: string;          // Primary Admin Contact
  contactPhone: string;          // Primary Admin Phone
  address: string;               // Head Office Address
  isActive: boolean;             // Tenant Account Status
  createdAt: Timestamp;          // Server Timestamp
  updatedAt: Timestamp;          // Server Timestamp
}
```

---

### 2.2 Collection: `users`
> Path: `users/{userId}`

```typescript
interface User {
  uid: string;                   // Firebase Auth UID
  organizationId: string;        // Multi-Tenant Isolation Key
  role: 'admin' | 'supervisor' | 'guard';
  employeeId: string;            // Unique Agency Code (e.g., "EMP-9021")
  fullName: string;              // Full Name
  phoneNumber: string;          // Mobile Contact
  email: string;                 // User Email
  profilePhotoUrl?: string;      // Optional Profile Photo URL
  assignedSiteIds: string[];     // Array of Site IDs (for Supervisors)
  isActive: boolean;             // Active Status Flag
  createdAt: Timestamp;          // Server Timestamp
  updatedAt: Timestamp;          // Server Timestamp
}
```

---

### 2.3 Collection: `sites`
> Path: `sites/{siteId}`

```typescript
interface Site {
  id: string;                    // Site ID (e.g., "site_techpark_01")
  organizationId: string;        // Multi-Tenant Isolation Key
  name: string;                  // Site Name (e.g., "Cyber Gateway Tech Park")
  address: string;               // Physical Address
  latitude: number;              // Geofence Center Latitude
  longitude: number;             // Geofence Center Longitude
  geofenceRadius: number;        // Geofence Radius in Meters (e.g., 50)
  qrToken: string;               // Dynamic Verification QR Token (e.g., "QR_SITE_99381")
  requiredGuardCount: number;    // Standard Staffing Requirement per Shift
  isActive: boolean;             // Active Site Flag
  createdAt: Timestamp;          // Server Timestamp
  updatedAt: Timestamp;          // Server Timestamp
}
```

---

### 2.4 Collection: `shifts`
> Path: `shifts/{shiftId}`

```typescript
interface Shift {
  id: string;                    // Shift ID (e.g., "shf_20260819_001")
  organizationId: string;        // Multi-Tenant Isolation Key
  siteId: string;                // Target Site ID
  siteName: string;              // Denormalized Site Name
  guardId: string;               // Assigned Guard User ID
  guardName: string;             // Denormalized Guard Full Name
  supervisorId: string;          // Assigned Supervisor ID
  shiftDate: string;             // Date String (YYYY-MM-DD)
  startTime: Timestamp;          // Scheduled Start Timestamp
  endTime: Timestamp;            // Scheduled End Timestamp
  status: 'scheduled' | 'in_progress' | 'completed' | 'missed' | 'cancelled';
  createdAt: Timestamp;          // Server Timestamp
  updatedAt: Timestamp;          // Server Timestamp
}
```

---

### 2.5 Collection: `attendance`
> Path: `attendance/{attendanceId}`

```typescript
interface Attendance {
  id: string;                    // Attendance Document ID (e.g., "att_shf_20260819_001")
  organizationId: string;        // Multi-Tenant Isolation Key
  shiftId: string;               // Linked Shift ID
  siteId: string;                // Linked Site ID
  guardId: string;               // Guard User ID
  
  // Check-In Data
  checkInTime: Timestamp;        // Server Timestamp of Check-In
  checkInLatitude: number;       // Captured Device Latitude
  checkInLongitude: number;      // Captured Device Longitude
  checkInAccuracy: number;       // GPS Accuracy in Meters
  checkInGeofenceDistance: number;// Distance to Site Center (Meters)
  checkInQrToken: string;        // Scanned QR Token
  
  // Check-Out Data (Optional until checkout occurs)
  checkOutTime?: Timestamp;       // Server Timestamp of Check-Out
  checkOutLatitude?: number;
  checkOutLongitude?: number;
  checkOutAccuracy?: number;
  
  verificationMethod: 'GPS_GEOFENCE_QR'; // Immutable Verification Type
  status: 'verified' | 'flagged' | 'manual_override';
  createdAt: Timestamp;          // Server Timestamp
  updatedAt: Timestamp;          // Server Timestamp
}
```

---

### 2.6 Collection: `incidents`
> Path: `incidents/{incidentId}`

```typescript
interface Incident {
  id: string;                    // Incident ID
  organizationId: string;        // Multi-Tenant Isolation Key
  siteId: string;                // Incident Location Site ID
  siteName: string;              // Denormalized Site Name
  reportedByGuardId: string;     // Guard UID
  reportedByGuardName: string;   // Denormalized Guard Name
  shiftId: string;               // Linked Active Shift ID
  
  type: 'theft' | 'vandalism' | 'trespassing' | 'equipment_failure' | 'medical' | 'other';
  severity: 'low' | 'medium' | 'high' | 'critical';
  description: string;           // Incident Details
  latitude: number;              // Event Geolocation Latitude
  longitude: number;             // Event Geolocation Longitude
  evidencePhotoUrls: string[];   // Firebase Storage Download URLs
  
  status: 'open' | 'under_review' | 'resolved';
  resolutionNotes?: string;      // Admin/Supervisor Notes upon resolution
  resolvedByUserId?: string;     // Resolver User ID
  resolvedAt?: Timestamp;        // Resolution Timestamp
  
  createdAt: Timestamp;          // Server Timestamp
  updatedAt: Timestamp;          // Server Timestamp
}
```

---

### 2.7 Collection: `alerts`
> Path: `alerts/{alertId}`

```typescript
interface Alert {
  id: string;                    // Alert ID
  organizationId: string;        // Multi-Tenant Isolation Key
  siteId: string;                // Related Site ID
  shiftId?: string;              // Optional Related Shift ID
  type: 'missed_shift' | 'late_checkin' | 'understaffed_site' | 'critical_incident';
  message: string;               // Human Readable Notification Message
  severity: 'warning' | 'critical';
  isAcknowledged: boolean;       // Supervisor/Admin Acknowledgment
  acknowledgedByUserId?: string;
  createdAt: Timestamp;          // Server Timestamp
}
```

---

### 2.8 Collection: `auditLogs`
> Path: `auditLogs/{auditId}`

```typescript
interface AuditLog {
  id: string;                    // Audit Record ID
  organizationId: string;        // Multi-Tenant Isolation Key
  actorId: string;               // Performing User ID
  actorName: string;             // Denormalized Performing User Name
  actorRole: 'admin' | 'supervisor' | 'guard';
  action: string;                // Action Code (e.g. "SHIFT_CREATED", "CHECK_IN")
  entityType: 'shift' | 'site' | 'user' | 'attendance' | 'incident';
  entityId: string;              // Modified Entity ID
  timestamp: Timestamp;          // Server Timestamp
  metadata: Record<string, any>; // JSON Details Payload
}
```

---

### 2.9 Collection: `dashboardStats`
> Path: `dashboardStats/{organizationId}`

```typescript
interface DashboardStats {
  organizationId: string;        // Document ID equals organizationId
  totalGuards: number;
  activeGuardsOnDuty: number;
  absentGuardsToday: number;
  lateCheckInsToday: number;
  activeSitesCount: number;
  understaffedSitesCount: number;
  openIncidentsCount: number;
  criticalAlertsCount: number;
  lastUpdated: Timestamp;        // Server Timestamp
}
```

---

## 3. Required Composite Indexes (`firestore.indexes.json`)

To prevent runtime index errors during complex queries:

```json
{
  "indexes": [
    {
      "collectionGroup": "shifts",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "organizationId", "order": "ASCENDING" },
        { "fieldPath": "guardId", "order": "ASCENDING" },
        { "fieldPath": "shiftDate", "order": "ASCENDING" }
      ]
    },
    {
      "collectionGroup": "shifts",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "organizationId", "order": "ASCENDING" },
        { "fieldPath": "siteId", "order": "ASCENDING" },
        { "fieldPath": "startTime", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "incidents",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "organizationId", "order": "ASCENDING" },
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "attendance",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "organizationId", "order": "ASCENDING" },
        { "fieldPath": "guardId", "order": "ASCENDING" },
        { "fieldPath": "checkInTime", "order": "DESCENDING" }
      ]
    }
  ]
}
```
