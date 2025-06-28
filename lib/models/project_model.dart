import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  final String id;
  final String craftsmanId;
  final String title;
  final String description;
  final List<String> imageUrls;
  final String craftCategory;
  final DateTime createdAt;
  final bool isActive;

  ProjectModel({
    required this.id,
    required this.craftsmanId,
    required this.title,
    required this.description,
    required this.imageUrls,
    required this.craftCategory,
    required this.createdAt,
    this.isActive = true,
  });

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      id: map['id'] ?? '',
      craftsmanId: map['craftsmanId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      craftCategory: map['craftCategory'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'craftsmanId': craftsmanId,
      'title': title,
      'description': description,
      'imageUrls': imageUrls,
      'craftCategory': craftCategory,
      'createdAt': Timestamp.fromDate(createdAt),
      'isActive': isActive,
    };
  }

  ProjectModel copyWith({
    String? id,
    String? craftsmanId,
    String? title,
    String? description,
    List<String>? imageUrls,
    String? craftCategory,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      craftsmanId: craftsmanId ?? this.craftsmanId,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      craftCategory: craftCategory ?? this.craftCategory,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
} 