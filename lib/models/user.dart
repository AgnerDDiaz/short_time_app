class GetAllClientsResponseDto {
  final List<GetUserByIdResponseDto> results;

  GetAllClientsResponseDto({required this.results});

  factory GetAllClientsResponseDto.fromJson( dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON format for GetAllClientsResponseDto: $json');
    }
    return GetAllClientsResponseDto(
      results: (json['results'] as List)
          .map((i) => GetUserByIdResponseDto.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
  }
}

class GetUserByIdResponseDto {
  final int id;
  final String role;
  final String name;
  final String email;
  final String? profilePicture;
  final dynamic createdAt;
  final String? businessName;
  final String? businessAddress;
  final String? phoneNumber;

  GetUserByIdResponseDto({
    required this.id,
    required this.role,
    required this.name,
    required this.email,
    this.profilePicture,
    required this.createdAt,
    this.businessName,
    this.businessAddress,
    this.phoneNumber,
  });

  factory GetUserByIdResponseDto.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON format for GetUserByIdResponseDto: $json');
    }
    return GetUserByIdResponseDto(
      id: json['id'] as int,
      role: json['role'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      profilePicture: json['profile_picture'] as String?,
      createdAt: json['created_at'],
      businessName: json['business_name'] as String?,
      businessAddress: json['business_address'] as String?,
      phoneNumber: json['phone_number'] as String?,
    );
  }
}

class UpdateUserDto {
  final String? role;
  final String? name;
  final String? email;
  final String? passwordHash;
  final String? profilePicture;
  final String? businessName;
  final String? businessAddress;
  final String? phoneNumber;

  UpdateUserDto({
    this.role,
    this.name,
    this.email,
    this.passwordHash,
    this.profilePicture,
    this.businessName,
    this.businessAddress,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
        if (role != null) 'role': role,
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (passwordHash != null) 'password_hash': passwordHash,
        if (profilePicture != null) 'profile_picture': profilePicture,
        if (businessName != null) 'business_name': businessName,
        if (businessAddress != null) 'business_address': businessAddress,
        if (phoneNumber != null) 'phone_number': phoneNumber,
      };
}