import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forms_app/presentation/blocs/register/register_cubit.dart';

import '../widgets/widgets.dart';

class FormScreen extends StatelessWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('New user'),
        ),
        body: const _FormView()
      ),
    );
  }
}

class _FormView extends StatefulWidget {
  const _FormView({
    Key? key,
  }) : super(key: key);

  @override
  State<_FormView> createState() => _FormViewState();
}

class _FormViewState extends State<_FormView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String username = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final registerCubit = context.read<RegisterCubit>();
    final state = context.watch<RegisterCubit>().state;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          const FlutterLogo(),
          const SizedBox(height: 10),
          CustomTextFormField(
            errorMessage: state.username.errorMessage,
            label: 'Nombre de usuario',
            onChanged: registerCubit.usernameChanged
          ),
          const SizedBox(height: 10),
          CustomTextFormField(
            errorMessage: state.email.errorMessage,
            label: 'Correo electrónico',
            onChanged: registerCubit.emailChanged
          ),
          const SizedBox(height: 10),
          CustomTextFormField(
            errorMessage: state.password.errorMessage,
            label: 'Contraseña',
            obscureText: true,
            onChanged: registerCubit.passwordChanged
          ),
          const SizedBox(height: 20),
          FilledButton.tonalIcon(
            onPressed: () {
              registerCubit.onSubmit();
            },
            icon: const Icon(Icons.save),
            label: const Text('Crear usuario'),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
