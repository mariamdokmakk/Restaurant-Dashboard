// class AppUser {
//   String id;
//   String name;
//   int phone;
//   String email;
//   String gender;
//   double longutude;
//   double latitude;
//   AppUser({
//     required this.id,
//     required this.name,
//     required this.phone,
//     required this.email,
//     required this.gender,
//     required this.longutude,
//     required this.latitude,
//   });
//
//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'id': id,
//       'name': name,
//       'phone': phone,
//       'email': email,
//       'gender': gender,
//       'longutude': longutude,
//       'latitude': latitude,
//     };
//   }
//
//   factory AppUser.fromMap(Map<String, dynamic> map) {
//     return AppUser(
//       id: map['id'] as String,
//       name: map['name'] as String,
//       phone: map['phone'] as int,
//       email: map['email'] as String,
//       gender: map['gender'] as String,
//       longutude: map['longutude'] as double,
//       latitude: map['latitude'] as double,
//     );
//   }
// }

// class AppUser {
//   String id;
//   String name;
//   String phone;
//   String email;
//   String? gender;
//   double latitude;
//   double longitude;
//   String? profileImage;
//
//   AppUser({
//     required this.id,
//     required this.name,
//     required this.phone,
//     required this.email,
//     this.gender,
//     required this.latitude,
//     required this.longitude,
//     this.profileImage,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'uid': id,
//       'name': name,
//       'email': email,
//       'phone': phone,
//       'profile_image': profileImage,
//       'location': {
//         'latitude': latitude,
//         'longitude': longitude,
//       }
//     };
//   }
//
//   factory AppUser.fromMap(Map<String, dynamic> map) {
//     return AppUser(
//       id: map['uid'] ?? '',
//       name: map['name'] ?? '',
//       email: map['email'] ?? '',
//       phone: map['phone'] ?? '',
//       profileImage: map['profile_image'],
//       gender: map['gender'],
//       latitude: map['location']?['latitude'] ?? 0,
//       longitude: map['location']?['longitude'] ?? 0,
//     );
//   }
// }

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
      'location': {
        'latitude': latitude,
        'longitude': longitude,
      },
      'profile_image': profileImage,
    };
  }
}


