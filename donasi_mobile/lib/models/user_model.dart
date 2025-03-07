class User {
  final String id;
  final String name;
  final String email;
  final String? role;
  final String? phone; // Optional jika ada
  final double? latitude; // Optional jika ada
  final double? longitude; // Optional jika ada
  final String? token; // Untuk menyimpan token jika dibutuhkan

  User({
    required this.id,
    required this.name,
    required this.email,
    this.role,
    this.phone,
    this.latitude,
    this.longitude,
    this.token,
  });

  // Factory method untuk membuat User dari JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      phone: json['phone'],
      latitude: json['latitude'] != null ? double.parse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.parse(json['longitude'].toString()) : null,
      token: json['token'],
    );
  }

  // Convert User ke JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "role": role,
      "phone": phone,
      "latitude": latitude,
      "longitude": longitude,
      "token": token,
    };
  }
}
