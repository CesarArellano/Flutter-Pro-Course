import 'package:dio/dio.dart';

import '../../../../config/config.dart';
import '../../domain/domain.dart';

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
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) {
    // TODO: implement createUpdateProduct
    throw UnimplementedError();
  }

  @override
  Future<Product> getProductById(String id) {
    // TODO: implement getProductById
    throw UnimplementedError();
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
      return [];
    }
  }

  @override
  Future<List<Product>> searchProductByTerm(String term) {
    // TODO: implement searchProductByTerm
    throw UnimplementedError();
  }
  
}