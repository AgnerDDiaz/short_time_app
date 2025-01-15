// lib/models/user_profile.dart

class UserProfile {
  final int userID;
  final String nombre;
  final String email;
  final String? fotoPerfil;
  final String role;
  final String password;

  UserProfile({
    required this.userID,
    required this.nombre,
    required this.email,
    this.fotoPerfil,
    required this.role,
    required this.password,
  });


  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'nombre': nombre,
      'email': email,
      'fotoPerfil': fotoPerfil,
      'role': role,
    };
  }


  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      userID: map['userID'],
      nombre: map['nombre'],
      email: map['email'],
      fotoPerfil: map['fotoPerfil'],
      role: map['role'],
      password: map['password'],
    );
  }

  UserProfile copyWith({
    int? userID,
    String? nombre,
    String? email,
    String? fotoPerfil,
    String? role,
    String? password,
  }) {
    return UserProfile(
      userID: userID ?? this.userID,
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      fotoPerfil: fotoPerfil ?? this.fotoPerfil,
      role: role ?? this.role,
      password: password ?? this.password,
    );
  }
}