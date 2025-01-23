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
  final bool verified;

  GetUserByIdResponseDto({
    required this.id,
    required this.role,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.verified,
    this.profilePicture,
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
      verified: json['verified'] as bool,
    );
  }
}

class UpdateUserDto {
  final String? name;
  final String? email;
  final String? businessName;
  final String? businessAddress;
  final String? phoneNumber;

  UpdateUserDto({
    this.name,
    this.email,
    this.businessName,
    this.businessAddress,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (businessName != null) 'business_name': businessName,
        if (businessAddress != null) 'business_address': businessAddress,
        if (phoneNumber != null) 'phone_number': phoneNumber,
      };
}