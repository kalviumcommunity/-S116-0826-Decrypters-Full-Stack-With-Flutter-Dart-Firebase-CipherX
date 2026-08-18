# CipherX — Audit Logging Architecture Specification 📝

> **Application Name**: CipherX  
> **Founding Team**: Team Decrypters (Hardik, Gauri, Avadhut)  
> **Document Version**: 1.0.0  

---

## 1. Audit Principles & Operational Compliance

Security workforce operations require an immutable, verifiable record of all administrative, roster, attendance, and security incident changes.

### Core Principles:
- **Append-Only Immutability**: Audit log entries can ONLY be created (`allow create`). Modifications (`allow update`) and deletions (`allow delete`) are strictly forbidden at the Security Rules layer.
- **Server Timestamp Enforced**: Audit timestamps use `request.time` to prevent clock tampering.
- **Actor Accountability**: Every log entry records `actorId`, `actorName`, and `actorRole` of the user triggering the action.

---

## 2. Tracked Operational Event Taxonomy

| Event Code | Trigger Description | Actor Role | Payload Metadata |
| :--- | :--- | :--- | :--- |
| `USER_CREATED` | New Guard or Supervisor account created. | Admin | `{ "newUserId": "usr_102", "role": "guard", "employeeId": "EMP-881" }` |
| `USER_DEACTIVATED` | User account deactivated. | Admin | `{ "deactivatedUserId": "usr_102", "reason": "Resigned" }` |
| `SITE_CREATED` | New client site added to roster. | Admin | `{ "siteId": "site_99", "geofenceRadius": 50 }` |
| `SHIFT_CREATED` | Shift assigned to a guard. | Admin / Supervisor | `{ "shiftId": "shf_01", "guardId": "usr_102", "siteId": "site_99" }` |
| `SHIFT_CANCELLED` | Shift cancelled by management. | Admin / Supervisor | `{ "shiftId": "shf_01", "cancellationReason": "Client requested" }` |
| `CHECK_IN_SUCCESS` | Guard executes multi-factor check-in. | Guard | `{ "shiftId": "shf_01", "gpsAccuracy": 12.4, "distance": 18.2 }` |
| `CHECK_IN_FAILED` | Check-in rejected by engine. | Guard | `{ "shiftId": "shf_01", "rejectionReason": "Outside Geofence" }` |
| `CHECK_OUT_SUCCESS` | Guard executes shift check-out. | Guard | `{ "shiftId": "shf_01", "checkOutTime": "2026-08-19T18:00:00Z" }` |
| `INCIDENT_CREATED` | On-site incident submitted. | Guard / Supervisor | `{ "incidentId": "inc_44", "severity": "critical", "type": "theft" }` |
| `INCIDENT_RESOLVED` | Incident marked resolved. | Admin / Supervisor | `{ "incidentId": "inc_44", "resolutionNotes": "Police filed report" }` |

---

## 3. Data Schema: `auditLogs/{auditId}`

```typescript
interface AuditLog {
  id: string;                    // Auto-generated Unique Document ID
  organizationId: string;        // Multi-Tenant Partition Key
  actorId: string;               // Performing User Firebase Auth UID
  actorName: string;             // Denormalized Actor Full Name
  actorRole: 'admin' | 'supervisor' | 'guard';
  action: string;                // Event Taxonomy Code (e.g. "CHECK_IN_SUCCESS")
  entityType: 'user' | 'site' | 'shift' | 'attendance' | 'incident';
  entityId: string;              // Target Modified Document ID
  timestamp: Timestamp;          // Server Timestamp
  metadata: Record<string, any>; // JSON Metadata Payload
}
```

---

## 4. Audit Logger Service Pattern (`lib/core/services/`)

```dart
class AuditLoggerService {
  final FirebaseFirestore _firestore;

  Future<void> logEvent({
    required User actor,
    required String action,
    required String entityType,
    required String entityId,
    Map<String, dynamic> metadata = const {},
  }) async {
    final auditDocRef = _firestore.collection('auditLogs').doc();
    
    await auditDocRef.set({
      'id': auditDocRef.id,
      'organizationId': actor.organizationId,
      'actorId': actor.uid,
      'actorName': actor.fullName,
      'actorRole': actor.role.name,
      'action': action,
      'entityType': entityType,
      'entityId': entityId,
      'timestamp': FieldValue.serverTimestamp(),
      'metadata': metadata,
    });
  }
}
```
