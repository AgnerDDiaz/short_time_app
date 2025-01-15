import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class UserProfile {
  final int userID;
  final String nombre;
  final String email;
  final String? fotoPerfil;
  final String role;
  String password;

  UserProfile({
    required this.userID,
    required this.nombre,
    required this.email,
    this.fotoPerfil,
    required this.role,
    required this.password,
  });

}