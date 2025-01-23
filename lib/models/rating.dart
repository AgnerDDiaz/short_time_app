class CreateRatingDto {
  final num userId;
  final num serviceId;
  final num reservationId;
  final String comment;
  final String? response;
  final String commentDate;
  final String? responseDate;
  final String rating;

  CreateRatingDto({
    required this.userId,
    required this.serviceId,
    required this.reservationId,
    required this.comment,
    this.response,
    required this.commentDate,
    this.responseDate,
    required this.rating,
  });

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'service_id': serviceId,
    'reservation_id': reservationId,
    'comment': comment,
    'response': response,
    'commentDate': commentDate,
    'responseDate': responseDate,
    'rating': rating,
  };
}

class CreateRatingResponseDto {
  final int id;
  final num userId;
  final num serviceId;
  final num reservationId;
  final String comment;
  final String? response;
  final dynamic commentDate;
  final dynamic responseDate;
  final String rating;

  CreateRatingResponseDto({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.reservationId,
    required this.comment,
    this.response,
    required this.commentDate,
    this.responseDate,
    required this.rating,
  });

  factory CreateRatingResponseDto.fromJson( dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON format for CreateRatingResponseDto: $json');
    }
    return CreateRatingResponseDto(
      id: json['id'] as int,
      userId: json['user_id'],
      serviceId: json['service_id'],
      reservationId: json['reservation_id'],
      comment: json['comment'] as String,
      response: json['response'] as String?,
      commentDate: json['commentDate'],
      responseDate: json['responseDate'],
      rating: json['rating'] as String,
    );
  }
}

class GetAllRatingsDto {
  final List<RatingDto> results;

  GetAllRatingsDto({required this.results});

  factory GetAllRatingsDto.fromJson( dynamic json) {
    if (json == null ) {
      throw FormatException('Invalid JSON format for GetAllRatingsDto: $json');
    }
    return GetAllRatingsDto(
      results: (json['results'] as List)
          .map((i) => RatingDto.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
  }
}

class RatingDto {
  final int id;
  final num userId;
  final num serviceId;
  final num reservationId;
  final String comment;
  final String? response;
  final dynamic commentDate;
  final dynamic responseDate;
  final String rating;

  RatingDto({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.reservationId,
    required this.comment,
    this.response,
    required this.commentDate,
    this.responseDate,
    required this.rating,
  });

  factory RatingDto.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON format for RatingDto: $json');
    }
    return RatingDto(
      id: json['id'] as int,
      userId: json['user_id'],
      serviceId: json['service_id'],
      reservationId: json['reservation_id'],
      comment: json['comment'] as String,
      response: json['response'] as String?,
      commentDate: json['commentDate'],
      responseDate: json['responseDate'],
      rating: json['rating'] as String,
    );
  }
}

class UpdateRatingDto {
  final num? id;
  final String? comment;
  final String? response;
  final dynamic commentDate;
  final dynamic responseDate;
  final String? rating;

  UpdateRatingDto({
    this.id,
    this.comment,
    this.response,
    this.commentDate,
    this.responseDate,
    this.rating,
  });

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    if (comment != null) 'comment': comment,
    if (response != null) 'response': response,
    if (commentDate != null) 'commentDate': commentDate,
    if (responseDate != null) 'responseDate': responseDate,
    if (rating != null) 'rating': rating,
  };
}