import 'package:flutter/material.dart';
import '../../data/models/item.dart';

class TaskListItem extends StatelessWidget {
  final Item task;
  final VoidCallback onToggleStatus;
  final VoidCallback onTap;

  const TaskListItem({
    Key? key,
    required this.task,
    required this.onToggleStatus,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        title: Text(task.name),
        subtitle: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.description),
              Text('Status: ${task.status.toString().split('.').last}'),
              Text('Priority: ${task.priority.toString().split('.').last}'),
              Text('Created: ${task.createdAt.toLocal().toString().split('.')[0]}'),
            ],
          ),
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
              onPressed: onToggleStatus,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}