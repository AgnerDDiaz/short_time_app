import 'package:short_time_app/api/api_client.dart';
import 'package:short_time_app/models/api.dart';
import 'package:short_time_app/models/category.dart';
import 'package:short_time_app/models/service.dart';

class CategoryService {
  final ShortTimeApiClient _apiClient;

  CategoryService({required ShortTimeApiClient apiClient}) : _apiClient = apiClient;

  Future<CreateCategoryResponseDto> createCategory(CreateCategoryDto createCategoryDto) async {
    try {
      return await _apiClient.makeRequest<CreateCategoryResponseDto>(
        'POST',
        '/categories',
        body: createCategoryDto.toJson(),
        fromJson: CreateCategoryResponseDto.fromJson,
      );
    } on ApiException catch (e) {
      rethrow;
    }
  }

  Future<GetCategoryByIdDto> getCategoryById(num id) async {
    try {
      return await _apiClient.makeRequest<GetCategoryByIdDto>(
        'GET',
        '/categories/$id',
        fromJson: GetCategoryByIdDto.fromJson,
      );
    } on ApiException catch (e) {
      rethrow;
    }
  }

  Future<MessageResponseDto> updateCategory(num id, UpdateCategoryDto updateCategoryDto) async {
    try {
      return await _apiClient.makeRequest<MessageResponseDto>(
        'PUT',
        '/categories/$id',
        body: updateCategoryDto.toJson(),
        fromJson: MessageResponseDto.fromJson,
      );
    } on ApiException catch (e) {
      rethrow;
    }
  }

  Future<MessageResponseDto> deleteCategory(num id) async {
    try {
      return await _apiClient.makeRequest<MessageResponseDto>(
        'DELETE',
        '/categories/$id',
        fromJson: MessageResponseDto.fromJson,
      );
    } on ApiException catch (e) {
      rethrow;
    }
  }

  Future<GetAllCategoriesResponseDto> getAllCategories() async {
    try {
      return await _apiClient.makeRequest<GetAllCategoriesResponseDto>('GET', '/categories/all', fromJson: GetAllCategoriesResponseDto.fromJson);
    } on ApiException catch (e) {
      rethrow;
    }
  }

  // Future<GetAllServicesResponseDto> getServicesByCategoryId(num id) async {
  //   try {
  //     return await _apiClient.makeRequest<GetAllServicesResponseDto>('GET', '/categories/$id/services', fromJson: GetAllServicesResponseDto.fromJson);
  //   } on ApiException catch (e) {
  //     rethrow;
  //   }
  // }
}
