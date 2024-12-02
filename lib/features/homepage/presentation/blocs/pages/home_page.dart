import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../di/service_locator.dart' as di;
import '../../../../auth/presentation/blocs/auth/auth_bloc.dart';
import '../../../../auth/presentation/blocs/pages/login_page.dart';
import '../home/home_bloc.dart';
import '../widgets/home_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutEvent());
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (Route<dynamic> route) => false, // Remove all routes
              );
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => di.getIt<HomeBloc>()..add(GetTasksEvent()),
        child: TaskList(),
      ),
    );
  }
}
