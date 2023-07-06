import 'package:teslo_shop/features/auth/infrastructured/datasources/auth_datasource_impl.dart';

import '../../domain/datasources/auth_datasource.dart';
import '../../domain/entities/user.dart';

import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource dataSource;

  AuthRepositoryImpl({
    AuthDatasource? dataSource
  }): dataSource = dataSource ?? AuthDatasourceImpl();
  
  @override
  Future<User> checkAuthStatus(String token) {
    return dataSource.checkAuthStatus(token);
  }

  @override
  Future<User> login(String email, String password) {
    return dataSource.login(email, password);
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    return dataSource.register(email, password, fullName);
  }
  
}