import 'package:flutter/material.dart';
import '../../data/models/item.dart';

class FilterControls extends StatelessWidget {
  final String sortBy;
  final ValueChanged<String?> onSortChanged;
  final Status? filterStatus;
  final ValueChanged<Status?> onStatusChanged;
  final Priority? filterPriority;
  final ValueChanged<Priority?> onPriorityChanged;

  const FilterControls({
    required this.sortBy,
    required this.onSortChanged,
    required this.filterStatus,
    required this.onStatusChanged,
    required this.filterPriority,
    required this.onPriorityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          DropdownButton<String>(
            value: sortBy,
            onChanged: onSortChanged,
            items: ['createdAt', 'priority'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text('Sort: ${value == 'createdAt' ? 'Date' : 'Priority'}'),
              );
            }).toList(),
          ),
          DropdownButton<Status?>(
            value: filterStatus,
            onChanged: onStatusChanged,
            items: [
              DropdownMenuItem(value: null, child: Text('All Statuses')),
              ...Status.values.map(
                (status) => DropdownMenuItem(
                  value: status,
                  child: Text(status.toString().split('.').last),
                ),
              ),
            ],
          ),
          DropdownButton<Priority?>(
            value: filterPriority,
            onChanged: onPriorityChanged,
            items: [
              DropdownMenuItem(value: null, child: Text('All Priorities')),
              ...Priority.values.map(
                (priority) => DropdownMenuItem(
                  value: priority,
                  child: Text(priority.toString().split('.').last),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
