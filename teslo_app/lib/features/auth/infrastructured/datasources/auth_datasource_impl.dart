
import 'package:dio/dio.dart';

import '../../../../config/config.dart';
import '../../domain/domain.dart';
import '../infrastructured.dart';

class AuthDatasourceImpl implements AuthDatasource {

  final dio = Dio(BaseOptions(
    baseUrl: Environment.apiUrl,
  ));

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final resp = await dio.get(
        '/auth/check-status',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          }
        )
      );
      final user = UserMapper.userJsonToEntity(resp.data);
      return user;
    } on DioException catch(e) {
      if( e.response?.statusCode == 401 ) {
        throw const CustomError('Token is not valid', 401);
      }

      if( e.type == DioExceptionType.connectionTimeout ) {
        throw const CustomError('Check your internet connection', 401);
      }
      throw Exception();
    } catch(e) {
      throw Exception();
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password
      });

      final user = UserMapper.userJsonToEntity(response.data);
      
      return user;

    } on DioException catch (e) {
      if( e.response?.statusCode == 401 ) {
        throw CustomError(e.response?.data['message'] ?? 'Credentials are not valid', 401);
      }

      if( e.type == DioExceptionType.connectionTimeout ) throw ConnectionTimeout();

      throw const CustomError('Something wrong happened', 500);
    } catch(e) {
      throw const CustomError('Something wrong happened', 500);
    }
  }

  @override
  Future<User> register(String email, String password, String fullName) async {
    try {
      final response = await dio.post('/auth/register', data: {
        'email': email,
        'password': password,
        'fullName': fullName
      });

      final user = UserMapper.userJsonToEntity(response.data);
      
      return user;

    } on DioException catch (e) {
      if( e.response?.statusCode == 401 ) {
        throw CustomError(e.response?.data['message'] ?? 'Credentials are not valid', 401);
      }

      if( e.type == DioExceptionType.connectionTimeout ) throw ConnectionTimeout();

      throw const CustomError('Something wrong happened', 500);
    } catch(e) {
      throw const CustomError('Something wrong happened', 500);
    }
  }
}