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
    Key? key,
    required this.sortBy,
    required this.onSortChanged,
    required this.filterStatus,
    required this.onStatusChanged,
    required this.filterPriority,
    required this.onPriorityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildDropdown<String>(
            context: context,
            value: sortBy,
            onChanged: onSortChanged,
            hint: 'Sort',
            items: {
              'createdAt': 'Date',
              'priority': 'Priority',
            },
          ),
          _buildDropdown<Status?>(
            context: context,
            value: filterStatus,
            onChanged: onStatusChanged,
            hint: 'Status',
            items: {
              null: 'All',
              for (var status in Status.values)
                status: status.toString().split('.').last,
            },
          ),
          _buildDropdown<Priority?>(
            context: context,
            value: filterPriority,
            onChanged: onPriorityChanged,
            hint: 'Priority',
            items: {
              null: 'All',
              for (var priority in Priority.values)
                priority: priority.toString().split('.').last,
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required BuildContext context,
    required T value,
    required ValueChanged<T?> onChanged,
    required String hint,
    required Map<T, String> items,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 110,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(1, 2),
          ),
        ],
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: colorScheme.onSurfaceVariant),
          style: textTheme.bodyMedium?.copyWith(fontSize: 14),
          dropdownColor: colorScheme.surfaceVariant,
          onChanged: onChanged,
          hint: Text(hint, style: textTheme.labelMedium),
          items: items.entries.map((entry) {
            return DropdownMenuItem<T>(
              value: entry.key,
              child: Text(
                entry.value,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium?.copyWith(fontSize: 14),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
