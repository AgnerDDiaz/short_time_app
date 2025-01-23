class ServiceInReservationDto {
  final int id;
  final int clientId;
  final String name;
  final String? description;
  final String price;
  final int serviceDuration;

  ServiceInReservationDto({
    required this.id,
    required this.clientId,
    required this.name,
    this.description,
    required this.price,
    required this.serviceDuration,
  });

  factory ServiceInReservationDto.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON format for ServiceInReservationDto: $json');
    }
    return ServiceInReservationDto(
      id: json['id'] as int,
      clientId: json['client_id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: json['price'] as String,
      serviceDuration: json['service_duration'] as int,
    );
  }
}

class SearchReservationResponseDto {
  final List<GetReservationResponseDto> results;

  SearchReservationResponseDto({required this.results});

  factory SearchReservationResponseDto.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON format for SearchReservationResponseDto: $json');
    }
    final resultsJson = json['results'] as List?;
    if(resultsJson == null){
      return SearchReservationResponseDto(results: []);
    }
    return SearchReservationResponseDto(
      results: resultsJson
          .map((item) => GetReservationResponseDto.fromJson(item as dynamic))
          .toList(),
    );
  }
}

class CreateReservationDto {
  final num userId;
  final num serviceId;
  final String date;
  final String startTime;
  final String endTime;
  final String status;

  CreateReservationDto({
    required this.userId,
    required this.serviceId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'service_id': serviceId,
        'date': date,
        'start_time': startTime,
        'end_time': endTime,
        'status': status,
      };
}

class CreateReservationResponseDto {
  final num userId;
  final num serviceId;
  final String date;
  final String startTime;
  final String endTime;
  final String status;

  CreateReservationResponseDto({
    required this.userId,
    required this.serviceId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  factory CreateReservationResponseDto.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON format for CreateReservationResponseDto: $json');
    }
    return CreateReservationResponseDto(
      userId: json['user_id'],
      serviceId: json['service_id'],
      date: json['date'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      status: json['status'] as String,
    );
  }
}

class GetReservationResponseDto {
  final num id;
  final num userId;
  final num serviceId;
  final String date;
  final String startTime;
  final String endTime;
  final String status;
  final ServiceInReservationDto service;

  GetReservationResponseDto({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.service,
  });

  factory GetReservationResponseDto.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON format for GetReservationResponseDto: $json');
    }
    return GetReservationResponseDto(
      id: json['id'],
      userId: json['user_id'],
      serviceId: json['service_id'],
      date: json['date'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      status: json['status'] as String,
      service: ServiceInReservationDto.fromJson(json['service']),
    );
  }
}

class UpdateReservationDto {
  final num? userId;
  final num? serviceId;
  final String? date;
  final String? startTime;
  final String? endTime;
  final String? status;

  UpdateReservationDto({
    this.userId,
    this.serviceId,
    this.date,
    this.startTime,
    this.endTime,
    this.status,
  });

  Map<String, dynamic> toJson() => {
    if (userId != null) 'user_id': userId,
    if (serviceId != null) 'service_id': serviceId,
    if (date != null) 'date': date,
    if (startTime != null) 'start_time': startTime,
    if (endTime != null) 'end_time': endTime,
    if (status != null) 'status': status,
  };
}