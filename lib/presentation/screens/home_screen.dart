import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/item.dart' show Item, Status;
import '../../business_logic/bloc/item_bloc.dart';
import '../widgets/task_detail_dialog.dart';
import '../widgets/add_task_bottom_sheet.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TaskMaster'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              context.read<ItemBloc>().add(LoadItems());
            },
            tooltip: 'Refresh Tasks',
          ),
        ],
      ),
      body: BlocBuilder<ItemBloc, ItemState>(
        builder: (context, state) {
          if (state is ItemLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ItemLoaded) {
            final tasks = state.items;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    title: Text(task.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(task.description),
                        Text('Status: ${task.status.toString().split('.').last}'),
                        Text('Priority: ${task.priority.toString().split('.').last}'),
                        Text('Created: ${task.createdAt.toLocal().toString().split('.')[0]}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            task.status == Status.completed
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: task.status == Status.completed ? Colors.green : Colors.red,
                          ),
                          onPressed: () {
                            // Toggle task status
                            final updatedTask = Item(
                              id: task.id, // Include the existing ID
                              name: task.name,
                              description: task.description, // Fix typo
                              status: task.status == Status.completed
                                  ? Status.notCompleted
                                  : Status.completed,
                              createdAt: task.createdAt,
                              priority: task.priority,
                            );
                            // Use the actual item ID
                            context.read<ItemBloc>().add(UpdateItem(task.id!, updatedTask));
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.grey),
                          onPressed: () {
                            // Use the actual item ID
                            context.read<ItemBloc>().add(DeleteItem(task.id!));
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return TaskDetailDialog(task: task);
                        },
                      );
                    },
                  ),
                );
              },
            );
          } else if (state is ItemError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return Center(child: Text('No tasks yet.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true, // Allows the bottom sheet to take full height
            builder: (BuildContext context) {
              return AddTaskBottomSheet();
            },
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add Task',
      ),
    );
  }
}