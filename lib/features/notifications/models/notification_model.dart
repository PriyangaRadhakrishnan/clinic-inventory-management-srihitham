import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType {
  lowStock,
  expiryAlert,
  systemAlert
}

extension NotificationTypeExtension on NotificationType {
  String get name => toString().split('.').last;
}

NotificationType _typeFromString(String type) {
  switch (type) {
    case 'lowStock': return NotificationType.lowStock;
    case 'expiryAlert': return NotificationType.expiryAlert;
    case 'systemAlert': return NotificationType.systemAlert;
    default: return NotificationType.systemAlert;
  }
}

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.isRead = false,
    required this.createdAt,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map, String documentId) {
    return NotificationModel(
      id: documentId,
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      type: _typeFromString(map['type'] ?? 'systemAlert'),
      isRead: map['isRead'] ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'message': message,
      'type': type.name,
      'isRead': isRead,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
