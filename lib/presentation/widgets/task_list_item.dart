import 'package:flutter/material.dart';
import '../../data/models/item.dart';

class TaskListItem extends StatefulWidget {
  final Item task;
  final VoidCallback onToggleStatus;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TaskListItem({
    Key? key,
    required this.task,
    required this.onToggleStatus,
    required this.onTap,
    required this.onDelete,
  }) : super(key: key);

  @override
  _TaskListItemState createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem> {
  Color _getPriorityColor(BuildContext context, Priority priority) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (priority) {
      case Priority.high:
        return colorScheme.error;
      case Priority.moderate:
        return colorScheme.tertiary;
      case Priority.low:
        return colorScheme.secondary;
    }
  }

  String _capitalize(String s) =>
      s.isNotEmpty ? s[0].toUpperCase() + s.substring(1).toLowerCase() : s;

  Future<bool?> _confirmDismiss(DismissDirection direction) async {
    if (direction == DismissDirection.endToStart) {
      // Swiping from right to left (deletion)
      return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Deletion'),
            content: Text(
              'Are you sure you want to delete "${widget.task.name}"?',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete'),
              ),
            ],
          );
        },
      );
    }
    return Future.value(
      true,
    ); // Allow other dismiss directions (like left swipe for status toggle)
  }

  void _onDismissed(DismissDirection direction) {
    if (direction == DismissDirection.endToStart) {
      // Swiping from right to left (delete)
      widget.onDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isCompleted = widget.task.status == Status.completed;
    final priorityColor = _getPriorityColor(context, widget.task.priority);

    return Dismissible(
      key: Key(widget.task.id!), // Unique key for Dismissible
      direction: DismissDirection
          .endToStart, // Only allow right-to-left swipe for deletion
      confirmDismiss: _confirmDismiss,
      onDismissed: _onDismissed,
      background: Container(
        color: Colors.red, // Background for right swipe (delete)
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
        child: Card(
          elevation: 2,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: priorityColor.withOpacity(0.5), width: 1),
          ),
          color: Theme.of(context).cardColor,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 6,
            ), // Reduced horizontal padding
            leading: IconButton(
              icon: Icon(
                isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isCompleted
                    ? Colors.green
                    : colorScheme.onSurface.withOpacity(0.6),
                size: 26,
              ),
              onPressed: widget.onToggleStatus,
              padding: EdgeInsets.zero, // Remove padding from IconButton
              constraints:
                  BoxConstraints(), // Remove constraints from IconButton
            ),
            title: Text(
              widget.task.name,
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
                color: isCompleted ? Colors.grey : colorScheme.onSurface,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.task.description.trim().isNotEmpty)
                    Text(
                      widget.task.description,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: -4,
                    children: [
                      _infoChip(
                        _capitalize(widget.task.status.name),
                        colorScheme.primary,
                      ),
                      _infoChip(
                        _capitalize(widget.task.priority.name),
                        priorityColor,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ), // Add spacing between chips and created date
                  _infoChip(
                    widget.task.createdAt.toLocal().toString().split('.')[0],
                    colorScheme.surfaceTint,
                  ), // Moved created date chip
                ],
              ),
            ),
            onTap: widget.onTap,
          ),
        ),
      ),
    );
  }

  Widget _infoChip(String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      constraints: const BoxConstraints(maxWidth: 130),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 11.5,
          color: color,
          fontWeight: FontWeight.w500,
          overflow: TextOverflow.ellipsis,
        ),
        softWrap: false,
      ),
    );
  }
}
