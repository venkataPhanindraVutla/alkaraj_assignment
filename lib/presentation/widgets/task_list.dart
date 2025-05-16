import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/bloc/item_bloc.dart';
import '../../data/models/item.dart';
import 'task_list_item.dart';
import 'task_detail_dialog.dart';

class TaskList extends StatelessWidget {
  final List<Item> tasks;

  const TaskList({required this.tasks});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(child: Text('No tasks yet. Add one using the + button!'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ItemBloc>().add(LoadItems());
      },
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Dismissible(
            key: Key(task.id!),
            direction: DismissDirection.endToStart,
            onDismissed: (_) {
              context.read<ItemBloc>().add(DeleteItem(task.id!));
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            child: TaskListItem(
              task: task,
              onToggleStatus: () {
                final updatedTask = task.copyWith(
                  status: task.status == Status.completed
                      ? Status.notCompleted
                      : Status.completed,
                );
                context.read<ItemBloc>().add(UpdateItem(task.id!, updatedTask));
              },
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => TaskDetailDialog(task: task),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
