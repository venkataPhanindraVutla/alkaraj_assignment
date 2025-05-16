import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/bloc/item_bloc.dart';
import '../../data/models/item.dart';

class TaskDetailDialog extends StatefulWidget {
  final Item task;

  const TaskDetailDialog({Key? key, required this.task}) : super(key: key);

  @override
  _TaskDetailDialogState createState() => _TaskDetailDialogState();
}

class _TaskDetailDialogState extends State<TaskDetailDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _description;
  late Status _status;
  late Priority _priority;

  @override
  void initState() {
    super.initState();
    _name = widget.task.name;
    _description = widget.task.description;
    _status = widget.task.status;
    _priority = widget.task.priority;
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final updatedTask = Item(
        id: widget.task.id, // Include the existing ID
        name: _name,
        description: _description, // Fix typo
        status: _status,
        createdAt: widget.task.createdAt, // Keep the original creation date
        priority: _priority,
      );
      // Use the actual item ID
      context.read<ItemBloc>().add(UpdateItem(widget.task.id!, updatedTask));
      Navigator.pop(context); // Close the dialog
    }
  }

  void _deleteTask() {
    // Use the actual item ID
    context.read<ItemBloc>().add(DeleteItem(widget.task.id!));
    Navigator.pop(context); // Close the dialog
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Task Details'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Task Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  _description = value!;
                },
              ),
              DropdownButtonFormField<Priority>(
                decoration: InputDecoration(labelText: 'Priority'),
                value: _priority,
                items: Priority.values.map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Text(priority.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _priority = value!;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Status:'),
                  DropdownButton<Status>(
                    value: _status,
                    items: Status.values.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _status = value!;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Text(
                'Created: ${widget.task.createdAt.toLocal().toString().split('.')[0]}',
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(child: Text('Delete'), onPressed: _deleteTask),
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        ElevatedButton(child: Text('Save'), onPressed: _saveChanges),
      ],
    );
  }
}
