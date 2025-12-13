class AppUser {
  String id;
  final String name;
  final String email;
  final String phone;
  // final String gender;
  final double latitude;
  final double longitude;
  final String profileImage;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    // required this.gender,
    required this.latitude,
    required this.longitude,
    required this.profileImage,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      // gender: map['gender'] ?? 'Male',

      // Location is stored as map in Firestore
      latitude: (map['location']?['latitude'] ?? 0).toDouble(),
      longitude: (map['location']?['longitude'] ?? 0).toDouble(),

      profileImage: map['profile_image'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': id,
      'name': name,
      'email': email,
      'phone': phone,
      // 'gender': gender,
      'location': {'latitude': latitude, 'longitude': longitude},
      'profile_image': profileImage,
    };
  }
}
