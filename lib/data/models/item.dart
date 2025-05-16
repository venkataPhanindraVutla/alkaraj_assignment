import 'package:cloud_firestore/cloud_firestore.dart';

enum Priority { high, moderate, low }
enum Status { completed, notCompleted }

class Item {
  final String? id;
  final String name;
  final String description;
  final Status status;
  final DateTime createdAt;
  final Priority priority;

  Item({
    this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.priority,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'status': status.name, 
      'priority': priority.name, 
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Item.fromJson(Map<String, dynamic> json, [String? id]) {
    final statusRaw = json['status'] ?? 'notCompleted';
    final priorityRaw = json['priority'] ?? 'low';

    return Item(
      id: id ?? json['id'], 
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      status: Status.values.firstWhere(
        (e) => e.name == statusRaw,
        orElse: () => Status.notCompleted,
      ),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      priority: Priority.values.firstWhere(
        (e) => e.name == priorityRaw,
        orElse: () => Priority.low,
      ),
    );
  }

  factory Item.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Item.fromJson(data, doc.id);
  }
}
