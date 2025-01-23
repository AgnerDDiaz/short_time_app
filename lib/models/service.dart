class CreateServiceDto {
  final int clientId;
  final String name;
  final String? description;
  final String price;
  final num? categoryId;
  final String? rating;
  final int serviceDuration;

  CreateServiceDto({
    required this.clientId,
    required this.name,
    this.description,
    required this.price,
    this.categoryId,
    this.rating,
    required this.serviceDuration,
  });

  Map<String, dynamic> toJson() => {
        'client_id': clientId,
        'name': name,
        'description': description,
        'price': price,
        'category_id': categoryId,
        'rating': rating,
        'service_duration': serviceDuration,
      };
}

class CreateServiceResponseDto {
  final int id;
  final int clientId;
  final String name;
  final String? description;
  final String price;
  final num? categoryId;
  final String? rating;
  final int serviceDuration;

  CreateServiceResponseDto({
    required this.id,
    required this.clientId,
    required this.name,
    this.description,
    required this.price,
    this.categoryId,
    this.rating,
    required this.serviceDuration,
  });

  factory CreateServiceResponseDto.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON format for CreateServiceResponseDto: $json');
    }
    return CreateServiceResponseDto(
      id: json['id'] as int,
      clientId: json['client_id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: json['price'] as String,
      categoryId: json['category_id'],
      rating: json['rating'] as String?,
      serviceDuration: json['service_duration'] as int,
    );
  }
}

class GetServiceByIdResponseDto {
  final int id;
  final int clientId;
  final String name;
  final String? description;
  final String price;
  final num? categoryId;
  final String? rating;
  final int serviceDuration;
  final String? picture;

  GetServiceByIdResponseDto({
    required this.id,
    required this.clientId,
    required this.name,
    this.description,
    required this.price,
    this.categoryId,
    this.rating,
    this.picture,
    required this.serviceDuration,
  });

  factory GetServiceByIdResponseDto.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON format for GetServiceByIdResponseDto: $json');
    }
    return GetServiceByIdResponseDto(
      id: json['id'] as int,
      clientId: json['client_id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: json['price'] as String,
      picture: json['picture'] as String?,
      categoryId: json['category_id'],
      rating: json['rating'] as String?,
      serviceDuration: json['service_duration'] as int,
    );
  }
}

class GetAllServicesResponseDto {
  final List<GetServiceByIdResponseDto> results;

  GetAllServicesResponseDto({required this.results});

  factory GetAllServicesResponseDto.fromJson(dynamic json) {
    if (json == null ) {
      throw FormatException('Invalid JSON format for GetAllServicesResponseDto: $json');
    }
    return GetAllServicesResponseDto(
      results: (json['results'] as List)
          .map((i) => GetServiceByIdResponseDto.fromJson(i))
          .toList(),
    );
  }
}

class UpdateServiceDto {
  final int? clientId;
  final String? name;
  final String? description;
  final String? price;
  final num? categoryId;
  final String? rating;
  final int? serviceDuration;

  UpdateServiceDto({
    this.clientId,
    this.name,
    this.description,
    this.price,
    this.categoryId,
    this.rating,
    this.serviceDuration,
  });

  Map<String, dynamic> toJson() => {
        if (clientId != null) 'client_id': clientId,
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (price != null) 'price': price,
        if (categoryId != null) 'category_id': categoryId,
        if (rating != null) 'rating': rating,
        if (serviceDuration != null) 'service_duration': serviceDuration,
      };
}