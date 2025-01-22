class Rating {
  final int id;
  final int userId;
  final int serviceId;
  final int reservationId;
  final String comment;
  final String? response;
  final String commentDate;
  final String? responseDate;
  final double rating;

  Rating({
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

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
    id: json["id"],
    userId: json["user_id"],
    serviceId: json["service_id"],
    reservationId: json["reservation_id"],
    comment: json["comment"],
    response: json["response"],
    commentDate: json["commentDate"],
    responseDate: json["responseDate"],
    rating: double.parse(json["rating"]),
  );
}
