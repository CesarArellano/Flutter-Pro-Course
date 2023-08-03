import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';

import '../../../shared/infrastructured/inputs/inputs.dart';

class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;
  final Password repeatPassword;
  final Username username;

  RegisterFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.repeatPassword = const Password.pure(),
    this.username = const Username.pure(),
  });

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
    Password? repeatPassword,
    Username? username,
  }) => RegisterFormState(
    isPosting: isPosting ?? this.isPosting,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isValid: isValid ?? this.isValid,
    email: email ?? this.email,
    password: password ?? this.password,
    repeatPassword: repeatPassword ?? this.repeatPassword,
    username: username ?? this.username
  );

  @override
  String toString() {
    return '''
      RegisterFormState:
        isPosting: $isPosting
        isFormPosted: $isFormPosted
        isValid: $isValid
        email: $email
        password: $password
        repeatPassword: $repeatPassword
        username: $username
    ''';
  }
}

class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  final Future<void> Function(String email, String password, String fullName) registerUserCallback;

  RegisterFormNotifier({
    required this.registerUserCallback
  }): super(RegisterFormState());

  void onUsernameChange( String value ) {
    final newUsername = Username.dirty(value);
    state = state.copyWith(
      username: newUsername,
      isValid: Formz.validate([ newUsername, state.repeatPassword, state.email, state.password ])
    );
  }

  void onEmailChange( String value ) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([ newEmail, state.repeatPassword, state.username, state.password ])
    );
  }

  void onPasswordChange( String value ) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([ newPassword, state.repeatPassword, state.email, state.username ])
    );
  }

  void onRepeatPasswordChange( String value ) {
    final newRepeatPassword = Password.dirty(value);
    state = state.copyWith(
      repeatPassword: newRepeatPassword,
      isValid: Formz.validate([ newRepeatPassword, state.password, state.email, state.username ])
    );
  }

  Future<void> onFormSubmit() async {
    _touchEveryField();
    if( !state.isValid ) return;

    state = state.copyWith(isPosting: true);
    await registerUserCallback(state.email.value, state.password.value, state.username.value);
    state = state.copyWith(isPosting: false);
  }

  void _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final repeatPassword = Password.dirty(state.repeatPassword.value);
    final username = Username.dirty(state.username.value);
    
    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      username: username,
      repeatPassword: repeatPassword,
      isValid: Formz.validate([ email, password, repeatPassword, username])
    );
  }
}

// Delete last state when the user log out.
final registerFormProvider = StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>((ref) {
  final registerUserCallback = ref.read(authProvider.notifier).registerUser;
  return RegisterFormNotifier(registerUserCallback: registerUserCallback);
});