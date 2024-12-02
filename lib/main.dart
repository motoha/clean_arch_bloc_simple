import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'core/token_provider.dart';
import 'di/service_locator.dart' as di;
import 'domain/repositories/auth_repository.dart';
import 'features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'features/auth/presentation/blocs/pages/login_page.dart';
import 'features/homepage/presentation/blocs/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.setup();
  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TokenProvider()),
        BlocProvider(create: (_) => di.getIt<AuthBloc>()),
      ],
      child: MaterialApp(
        home: FutureBuilder<String?>(
          future: di.getIt<AuthRepository>().getToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final token = snapshot.data;
              if (token != null) {
                return HomePage();
              } else {
                return LoginPage();
              }
            }
          },
        ),
      ),
    );
  }
}
