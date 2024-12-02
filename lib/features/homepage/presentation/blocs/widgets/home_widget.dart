import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home/home_bloc.dart';

class TaskList extends StatelessWidget {
  const TaskList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is TaskFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is HomeLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HomeLoaded) {
          final tasks = state.tasks.tasksDate;
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return ListTile(
                title: Text('Date: ${task.date}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status: ${task.statusKunjungan}'),
                    Text('Timestamp: ${task.timeStamp}'),
                    Text('Foto: ${task.fotoKunjungan}'),
                  ],
                ),
              );
            },
          );
        } else if (state is HomeError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return Container();
      },
    );
  }
}
