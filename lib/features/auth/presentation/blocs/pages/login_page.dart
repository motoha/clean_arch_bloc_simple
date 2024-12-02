import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth/auth_bloc.dart';
import '../widgets/login_form.dart';
import '../../../../../di/service_locator.dart' as di;

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocProvider(
        create: (context) => di.getIt<AuthBloc>(),
        child: LoginForm(),
      ),
    );
  }
}
