import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../business_logic/bloc/item_bloc.dart';
import '../../business_logic/theme/theme_notifier.dart';
import '../../data/models/item.dart';
import '../widgets/add_task_bottom_sheet.dart';
import '../widgets/filter_controls.dart';
import '../widgets/task_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _sortBy = 'createdAt';
  Status? _filterStatus;
  Priority? _filterPriority;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearching() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
        // Optionally trigger a state update if needed to show all tasks
        // context.read<ItemBloc>().add(LoadItems());
      }
    });
  }

  void _updateSearchQuery(String newQuery) {
    setState(() {
      _searchQuery = newQuery;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ItemBloc, ItemState>(
      listener: (context, state) {
        if (state is ItemOperationSuccess || state is ItemOperationFailure || state is ItemError) {
          final message = state is ItemOperationSuccess
              ? state.message
              : (state is ItemOperationFailure ? state.error : (state as ItemError).message);
          final color = state is ItemOperationSuccess ? Colors.green : Colors.red;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: color),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _isSearching
                ? TextField(
                    key: const ValueKey<bool>(true),
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search tasks...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white, fontSize: 18.0),
                    onChanged: _updateSearchQuery,
                  )
                : const Text('TaskMaster', key: ValueKey<bool>(false)),
          ),
          actions: [
            IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search),
              onPressed: _toggleSearching,
              tooltip: _isSearching ? 'Close Search' : 'Search',
            ),
            IconButton(
              icon: const Icon(Icons.brightness_6),
              onPressed: () {
                Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
              },
              tooltip: 'Toggle Theme',
            ),
          ],
        ),
        body: BlocBuilder<ItemBloc, ItemState>(
          builder: (context, state) {
            if (state is ItemLoading) return const Center(child: CircularProgressIndicator());
            if (state is ItemLoaded) {
              List<Item> tasks = state.items;

              // Filtering
              if (_filterStatus != null) {
                tasks = tasks.where((task) => task.status == _filterStatus).toList();
              }
              if (_filterPriority != null) {
                tasks = tasks.where((task) => task.priority == _filterPriority).toList();
              }

              // Searching
              if (_searchQuery.isNotEmpty) {
                tasks = tasks.where((task) =>
                    task.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                    task.description.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
              }

              // Sorting
              tasks.sort((a, b) {
                if (_sortBy == 'createdAt') return b.createdAt.compareTo(a.createdAt);
                if (_sortBy == 'priority') return a.priority.index.compareTo(b.priority.index);
                return 0;
              });

              return Column(
                children: [
                  FilterControls(
                    sortBy: _sortBy,
                    onSortChanged: (value) => setState(() => _sortBy = value!),
                    filterStatus: _filterStatus,
                    onStatusChanged: (value) => setState(() => _filterStatus = value),
                    filterPriority: _filterPriority,
                    onPriorityChanged: (value) => setState(() => _filterPriority = value),
                  ),
                  Expanded(child: TaskList(tasks: tasks)),
                ],
              );
            }

            if (state is ItemError) return Center(child: Text('Error: ${state.message}'));
            return const Center(child: Text('Press the + button to add a task!'));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => AddTaskBottomSheet(),
          ),
          child: const Icon(Icons.add),
          tooltip: 'Add Task',
        ),
      ),
    );
  }
}
