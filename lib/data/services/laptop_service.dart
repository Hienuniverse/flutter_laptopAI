import 'package:dio/dio.dart';

import '../models/category_model.dart';
import '../models/laptop_model.dart';

class LaptopService {
  final Dio _dio;

  LaptopService({Dio? dio})
      : _dio = dio ??
      Dio(
        BaseOptions(
          baseUrl: 'http://10.0.2.2:5000',
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

  Future<List<LaptopModel>> getLaptops() async {
    try {
      final response = await _dio.get('/api/products');

      final List data = _getListData(response.data);

      return data
          .map((item) => LaptopModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception('Lỗi lấy danh sách laptop: ${e.message}');
    } catch (e) {
      throw Exception('Lỗi không xác định khi lấy laptop: $e');
    }
  }

  Future<LaptopModel> getLaptopById(int id) async {
    try {
      final response = await _dio.get('/api/products/$id');

      final data = _getObjectData(response.data);

      return LaptopModel.fromJson(data);
    } on DioException catch (e) {
      throw Exception('Lỗi lấy chi tiết laptop: ${e.message}');
    } catch (e) {
      throw Exception('Lỗi không xác định khi lấy chi tiết laptop: $e');
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dio.get('/api/categories');

      final List data = _getListData(response.data);

      return data
          .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception('Lỗi lấy danh mục laptop: ${e.message}');
    } catch (e) {
      throw Exception('Lỗi không xác định khi lấy danh mục: $e');
    }
  }

  Future<List<LaptopModel>> searchLaptops(String keyword) async {
    try {
      final response = await _dio.get(
        '/api/products/search',
        queryParameters: {
          'keyword': keyword,
        },
      );

      final List data = _getListData(response.data);

      return data
          .map((item) => LaptopModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception('Lỗi tìm kiếm laptop: ${e.message}');
    } catch (e) {
      throw Exception('Lỗi không xác định khi tìm kiếm laptop: $e');
    }
  }

  List _getListData(dynamic data) {
    if (data is List) return data;

    if (data is Map<String, dynamic>) {
      if (data['data'] is List) return data['data'];
      if (data['products'] is List) return data['products'];
      if (data['laptops'] is List) return data['laptops'];
      if (data['result'] is List) return data['result'];
    }

    return [];
  }

  Map<String, dynamic> _getObjectData(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data['data'] is Map<String, dynamic>) {
        return data['data'] as Map<String, dynamic>;
      }

      if (data['product'] is Map<String, dynamic>) {
        return data['product'] as Map<String, dynamic>;
      }

      if (data['laptop'] is Map<String, dynamic>) {
        return data['laptop'] as Map<String, dynamic>;
      }

      return data;
    }

    return {};
  }
}