// availability_dtos.dart
class CreateAvailabilityDto {
  final num userId;
  final String day;
  final String openingTime;
  final String closingTime;

  CreateAvailabilityDto({
    required this.userId,
    required this.day,
    required this.openingTime,
    required this.closingTime,
  });

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'day': day,
        'opening_time': openingTime,
        'closing_time': closingTime,
      };
}

class CreateAvailabilityResponseDto {
  final int id;
  final num userId;
  final String day;
  final dynamic openingTime;
  final dynamic closingTime;

  CreateAvailabilityResponseDto({
    required this.id,
    required this.userId,
    required this.day,
    required this.openingTime,
    required this.closingTime,
  });

  factory CreateAvailabilityResponseDto.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON format for CreateAvailabilityResponseDto: $json');
    }
    return CreateAvailabilityResponseDto(
      id: json['id'] as int,
      userId: json['user_id'],
      day: json['day'] as String,
      openingTime: json['opening_time'],
      closingTime: json['closing_time'],
    );
  }
}

class AvailabilityOfDateDto {
  final num userId;
  final String date;
  final num duration;

  AvailabilityOfDateDto({
    required this.userId,
    required this.date,
    required this.duration,
  });

    Map<String, dynamic> toJson() => {
        'user_id': userId,
        'date': date,
        'duration': duration,
      };
}

class AvailabilityOfDateResponseDto {
  AvailabilityOfDateResponseDto();

  factory AvailabilityOfDateResponseDto.fromJson(Map<String, dynamic> json) {
    if (json == null || json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON format for AvailabilityOfDateResponseDto: $json');
    }
    return AvailabilityOfDateResponseDto(
    );
  }
}

class GetAvailabilityByIdResponseDto {
  final int id;
  final num userId;
  final String day;
  final dynamic openingTime;
  final dynamic closingTime;

  GetAvailabilityByIdResponseDto({
    required this.id,
    required this.userId,
    required this.day,
    required this.openingTime,
    required this.closingTime,
  });

  factory GetAvailabilityByIdResponseDto.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON format for GetAvailabilityByIdResponseDto: $json');
    }
    return GetAvailabilityByIdResponseDto(
      id: json['id'] as int,
      userId: json['user_id'],
      day: json['day'] as String,
      openingTime: json['opening_time'],
      closingTime: json['closing_time'],
    );
  }
}

class UpdateAvailabilityDto {
  final num? id;
  final num? userId;
  final String? day;
  final String? openingTime;
  final String? closingTime;

  UpdateAvailabilityDto({
    this.id,
    this.userId,
    this.day,
    this.openingTime,
    this.closingTime,
  });

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    if (userId != null) 'user_id': userId,
    if (day != null) 'day': day,
    if (openingTime != null) 'opening_time': openingTime,
    if (closingTime != null) 'closing_time': closingTime,
  };
}

class GetAvailabilityOfDateDto {
  final num userId;
  final String date;
  final num duration;

  GetAvailabilityOfDateDto({
    required this.userId,
    required this.date,
    required this.duration,
  });

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'date': date,
        'duration': duration,
      };
}

class AvailabilitySlotDto {
  final String startTime;
  final String endTime;
  final bool available;

  AvailabilitySlotDto({
    required this.startTime,
    required this.endTime,
    required this.available,
  });

  factory AvailabilitySlotDto.fromJson(Map<String, dynamic> json) {
    if (json == null || json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON format for AvailabilitySlotDto: $json');
    }
    return AvailabilitySlotDto(
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      available: json['available'] as bool,
    );
  }
}

class GetAvailabilityOfDateResponseDto {
  final List<AvailabilitySlotDto> results;

  GetAvailabilityOfDateResponseDto({required this.results});

  factory GetAvailabilityOfDateResponseDto.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON format for GetAvailabilityOfDateResponseDto: $json');
    }
    final resultsJson = json['results'] as List?;
    if (resultsJson == null) {
      return GetAvailabilityOfDateResponseDto(results: []);
    }
    return GetAvailabilityOfDateResponseDto(
      results: resultsJson
          .map((item) => AvailabilitySlotDto.fromJson(item as dynamic))
          .toList(),
    );
  }
}