import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../config/config.dart';
import '../../domain/domain.dart';
import '../errors/product_errors.dart';

class ProductsDatasourceImpl implements ProductsDatasource {
  late final Dio dio;
  final String accessToken;

  ProductsDatasourceImpl({
    required this.accessToken,
  }) : dio = Dio(BaseOptions(
    baseUrl: Environment.apiUrl,
    headers: {
      'Authorization': 'Bearer $accessToken'
    }
  ));
  
  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      final String? productId = productLike['id'];
      final String method = ( productId == null ) ? 'POST': 'PATCH';
      final String url = ( productId == null ) ? '/products' : '/products/$productId';
      productLike.remove('id');
      final response = await dio.request(
        url,
        data: productLike,
        options: Options(method: method)
      );
      return Product.fromJson(response.data);
    } catch (e) {
      log(e.toString());
      throw Exception();
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final resp = await dio.get('/products/$id');

      return Product.fromJson(resp.data);
    
    } on DioException {
      throw ProductNotFound();
    } catch (e) {
      log('ProductsDatasource: $e');
      throw Exception(e);
    }
  }

  @override
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0}) async {
    try {
      final resp = await dio.get<List>('/products', queryParameters: {
        'limit': limit,
        'offset': offset
      });
      
      List<Product> products = [];
      
      for (final product in resp.data ?? []) {
        products = [ ...products, Product.fromJson(product)];
      }

      return products;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  @override
  Future<List<Product>> searchProductByTerm(String term) {
    // TODO: implement searchProductByTerm
    throw UnimplementedError();
  }
  
}