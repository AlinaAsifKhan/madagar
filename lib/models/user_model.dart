class UserModel {
  final String uid;
  final String phoneNumber;
  final String name;
  final String role; // 'customer' or 'helper'
  final String? profileImageUrl;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.phoneNumber,
    required this.name,
    required this.role,
    this.profileImageUrl,
    required this.createdAt,
  });

  // Convert UserModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'phoneNumber': phoneNumber,
      'name': name,
      'role': role,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt,
    };
  }

  // Create UserModel from Firestore document
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      phoneNumber: json['phoneNumber'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      createdAt: (json['createdAt']).toDate() as DateTime,
    );
  }
}
