import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/domain/entities/user_mapper.dart';

import '../../domain/datasources/auth_datasource.dart';
import '../../domain/entities/user.dart';

class AuthDatasourceImpl implements AuthDatasource {

  final dio = Dio(BaseOptions(
    baseUrl: Environment.apiUrl,
  ));

  @override
  Future<User> checkAuthStatus(String token) {
    throw UnimplementedError();
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

    } catch (e) {
      log(e.toString());
      return const User(
        id: '',
        email: '',
        fullName: '',
        roles: [],
        token: ''
      );
    }
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    // TODO: implement register
    throw UnimplementedError();
  }
}