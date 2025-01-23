import 'dart:async';

import 'package:short_time_app/api/api_client.dart';


class CreateCategoryDto {
  final String name;

  CreateCategoryDto({required this.name});

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}

class CreateCategoryResponseDto {
  final int id;
  final String name;

  CreateCategoryResponseDto({required this.id, required this.name});

  factory CreateCategoryResponseDto.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON format for CreateCategoryResponseDto: $json');
    }
    return CreateCategoryResponseDto(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class GetCategoryByIdDto {
  final int id;
  final String name;

  GetCategoryByIdDto({required this.id, required this.name});

  factory GetCategoryByIdDto.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON format for GetCategoryByIdDto: $json');
    }
    return GetCategoryByIdDto(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class UpdateCategoryDto {
  final String? name;

  UpdateCategoryDto({this.name});

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
      };
}

class GetAllCategoriesResponseDto {
  final List<GetCategoryByIdDto> results;

  GetAllCategoriesResponseDto({required this.results});

  factory GetAllCategoriesResponseDto.fromJson(dynamic json) {
    if (json == null ) {
      throw FormatException('Invalid JSON format for GetAllCategoriesResponseDto: $json');
    }
    return GetAllCategoriesResponseDto(
      results: (json['results'] as List)
          .map((i) => GetCategoryByIdDto.fromJson(i))
          .toList(),
    );
  }
}

// service_dtos.dart (import this file)
// ... (GetAllServicesResponseDto from the service DTOs - no changes needed)