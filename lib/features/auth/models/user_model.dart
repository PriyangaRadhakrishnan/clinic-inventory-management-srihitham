import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String name;
  final String email;
  final String role; // 'admin', 'staff', 'unassigned'
  final String customId; // Custom sequential ID (e.g. U1)
  final DateTime? createdAt;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.customId,
    this.createdAt,
  });

  // Convert Firestore Map to AppUser Object
  factory AppUser.fromMap(Map<String, dynamic> map, String documentId) {
    return AppUser(
      uid: documentId,
      name: map['name'] ?? 'Unknown User',
      email: map['email'] ?? '',
      role: map['role'] ?? 'unassigned',
      customId: map['customId'] ?? '',
      createdAt: map['createdAt'] != null 
          ? (map['createdAt'] as Timestamp).toDate() 
          : null,
    );
  }

  // Convert AppUser Object to Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'customId': customId,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }

  // Helper getters for roles
  bool get isAdmin => role.toLowerCase() == 'admin';
  bool get isStaff => role.toLowerCase() == 'staff';
  bool get isUnassigned => role.toLowerCase() != 'admin' && role.toLowerCase() != 'staff';

  // Copy with method for immutability
  AppUser copyWith({
    String? uid,
    String? name,
    String? email,
    String? role,
    String? customId,
    DateTime? createdAt,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      customId: customId ?? this.customId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
