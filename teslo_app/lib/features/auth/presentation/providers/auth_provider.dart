
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/infrastructured/services/services.dart';
import '../../domain/domain.dart';
import '../../infrastructured/infrastructured.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServiceImpl();

  return AuthNotifier(
    authRepository: authRepository,
    keyValueStorageService: keyValueStorageService,
  );
});

class AuthNotifier extends StateNotifier<AuthState> {

  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;

  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorageService,
  }): super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on WrongCredentials {
      logout('The credentials are wrong');
    } on ConnectionTimeout {
      logout('Connection Timeout error');
    } on CustomError catch(e) {
      logout(e.message);
    } catch (e) {
      logout('Uncontrolled error');
    }
    
  }

  void registerUser( String email, String password, String username ) async {

  }

  Future<void> checkAuthStatus() async {
    final token = await keyValueStorageService.getValue<String>('token');
    log('checkAuthStatus: $token');
    if( token == null ) return logout();

    try {
      final user = await authRepository.checkAuthStatus(token);
      _setLoggedUser(user);
    } catch (e) {
      logout();
    }
  }

  Future<void> logout([ String? errorMessage ]) async {
    await keyValueStorageService.removeKey('token');
    state = state.copyWith(
      user: null,
      authStatus: AuthStatus.notAuthenticated,
      errorMessage: errorMessage
    );
  }

  Future<void> _setLoggedUser(User user) async {
    await keyValueStorageService.setKeyValue<String>('token', user.token);

    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: '',
    );
  }
}


enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking,
    this.user,
    this.errorMessage = ''
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage
  }) => AuthState(
    authStatus: authStatus ?? this.authStatus,
    user: user ?? this.user,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}