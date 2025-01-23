class MessageResponseDto {
  final String message;

  MessageResponseDto({required this.message});

  factory MessageResponseDto.fromJson(dynamic json) {
    // Check if json is null or not a Map
    if (json == null || json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON format for MessageResponseDto: $json');
    }

    // Check if 'message' key exists and is a String
    if (!json.containsKey('message') || json['message'] is! String) {
      throw FormatException('Missing or invalid "message" field in JSON: $json');
    }

    return MessageResponseDto(
      message: json['message'] as String,
    );
  }

    Map<String, dynamic> toJson() => {
        'message': message,
      };
}