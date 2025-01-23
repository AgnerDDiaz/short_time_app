class LoginDto {
  final String email;
  final String password;

  LoginDto({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

class LoginResponseDto {
  final String accessToken;

  LoginResponseDto({required this.accessToken});

  factory LoginResponseDto.fromJson(dynamic json) => LoginResponseDto(
        accessToken: json['access_token'] as String,
      );
}

enum Role { user, business, admin }

// Convert method for role
Role roleFromString(String role) {
  switch (role) {
    case 'user':
      return Role.user;
    case 'business':
      return Role.business;
    case 'admin':
      return Role.admin;
    default:
      return Role.user;
  }
}

String roleToString(Role role) {
  switch (role) {
    case Role.user:
      return 'user';
    case Role.business:
      return 'client';
    case Role.admin:
      return 'admin';
  }
}

class RegisterDto {
  final Role role;
  final String name;
  final String email;
  final String passwordHash;
  final String? profilePicture;
  final String? businessName;
  final String? businessAddress;
  final String? phoneNumber;

  RegisterDto({
    required this.role,
    required this.name,
    required this.email,
    required this.passwordHash,
    this.profilePicture,
    this.businessName,
    this.businessAddress,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
        'role': roleToString(role),
        'name': name,
        'email': email,
        'password_hash': passwordHash,
        'profile_picture': profilePicture,
        'business_name': businessName,
        'business_address': businessAddress,
        'phone_number': phoneNumber,
      };
}

class RegisterResponseDto {
  final int id;
  final Role role;
  final String name;
  final String email;
  final String? profilePicture;
  final String? businessName;
  final String? businessAddress;
  final String? phoneNumber;
  final dynamic createdAt;
  final bool verified;

  RegisterResponseDto({
    required this.id,
    required this.role,
    required this.name,
    required this.email,
    this.profilePicture,
    this.businessName,
    this.businessAddress,
    this.phoneNumber,
    required this.createdAt,
    required this.verified,
  });

  factory RegisterResponseDto.fromJson(dynamic json) => RegisterResponseDto(
        id: json['id'] as int,
        role: roleFromString(json['role'] as String),
        name: json['name'] as String,
        email: json['email'] as String,
        profilePicture: json['profile_picture'] as String?,
        businessName: json['business_name'] as String?,
        businessAddress: json['business_address'] as String?,
        phoneNumber: json['phone_number'] as String?,
        createdAt: json['created_at'],
        verified: json['verified'] as bool,
      );
}

class ChangePasswordDto {
  final String email;
  final String oldPassword;
  final String newPassword;

  ChangePasswordDto({
    required this.email,
    required this.oldPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      };
}

class ForgotPasswordDto {
  final String email;

  ForgotPasswordDto({required this.email});

  Map<String, dynamic> toJson() => {
        'email': email,
      };
}

class VerifyChangePasswordDto {
  final String email;
  final String newPassword;
  final int code;

  VerifyChangePasswordDto({
    required this.email,
    required this.newPassword,
    required this.code,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'newPassword': newPassword,
        'code': code,
      };
}

class VerifyEmailDto {
  final int code;

  VerifyEmailDto({required this.code});

  Map<String, dynamic> toJson() => {
        'code': code,
      };
}

class VerifyTokenResponseDto {
  final String email;
  final int sub;
  final Role role;
  final int iat;
  final int exp;

  VerifyTokenResponseDto({
    required this.email,
    required this.sub,
    required this.role,
    required this.iat,
    required this.exp,
  });

  factory VerifyTokenResponseDto.fromJson(dynamic json) =>
      VerifyTokenResponseDto(
        email: json['email'] as String,
        sub: json['sub'] as int,
        role: roleFromString(json['role'] as String),
        iat: json['iat'] as int,
        exp: json['exp'] as int,
      );
}
