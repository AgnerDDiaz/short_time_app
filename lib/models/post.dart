class Post {
  final String id;
  final String profileImageUrl;
  final String comment;
  final String foodPictureUrl;
  final String timestamp;

  Post({
    required this.id,
    required this.profileImageUrl,
    required this.comment,
    required this.foodPictureUrl,
    required this.timestamp,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        profileImageUrl: json["profileImageUrl"],
        comment: json["comment"],
        foodPictureUrl: json["foodPictureUrl"],
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profileImageUrl": profileImageUrl,
        "comment": comment,
        "foodPictureUrl": foodPictureUrl,
        "timestamp": timestamp,
      };
}
