import 'package:alkaraj_assignment/business_logic/theme/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/item.dart' show Item, Status, Priority;
import '../../business_logic/bloc/item_bloc.dart';
import 'package:provider/provider.dart';
import '../widgets/task_detail_dialog.dart';
import '../widgets/add_task_bottom_sheet.dart';
import '../widgets/task_list_item.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _sortBy = 'createdAt';
  Status? _filterStatus; 
  Priority? _filterPriority; 

  @override
  Widget build(BuildContext context) {
    return BlocListener<ItemBloc, ItemState>(
      listener: (context, state) {
        if (state is ItemOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is ItemOperationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        } else if (state is ItemError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error loading tasks: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('TaskMaster'),
          actions: [
            IconButton(
              icon: Icon(Icons.brightness_6),
              onPressed: () {
                Provider.of<ThemeNotifier>(
                  context,
                  listen: false,
                ).toggleTheme();
              },
              tooltip: 'Toggle Theme',
            ),
          ],
        ),

        body: BlocBuilder<ItemBloc, ItemState>(
          builder: (context, state) {
            if (state is ItemLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ItemLoaded) {
              List<Item> tasks = state.items;

              // Apply filtering
              if (_filterStatus != null) {
                tasks =
                    tasks
                        .where((task) => task.status == _filterStatus)
                        .toList();
              }
              if (_filterPriority != null) {
                tasks =
                    tasks
                        .where((task) => task.priority == _filterPriority)
                        .toList();
              }

              // Apply sorting
              tasks.sort((a, b) {
                if (_sortBy == 'createdAt') {
                  return b.createdAt.compareTo(a.createdAt);
                } else if (_sortBy == 'priority') {
                  return a.priority.index.compareTo(b.priority.index);
                }
                return 0;
              });

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        DropdownButton<String>(
                          value: _sortBy,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _sortBy = newValue;
                              });
                            }
                          },
                          items:
                              <String>['createdAt', 'priority'].map((
                                String value,
                              ) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    'Sort: ${value == 'createdAt' ? 'Date' : 'Priority'}',
                                  ),
                                );
                              }).toList(),
                        ),
                        DropdownButton<Status?>(
                          value: _filterStatus,
                          onChanged: (Status? newValue) {
                            setState(() {
                              _filterStatus = newValue;
                            });
                          },
                          items: [
                            DropdownMenuItem<Status?>(
                              value: null,
                              child: Text('All Statuses'),
                            ),
                            ...Status.values.map(
                              (status) => DropdownMenuItem<Status>(
                                value: status,
                                child: Text(status.toString().split('.').last),
                              ),
                            ),
                          ],
                        ),
                        DropdownButton<Priority?>(
                          value: _filterPriority,
                          onChanged: (Priority? newValue) {
                            setState(() {
                              _filterPriority = newValue;
                            });
                          },
                          items: [
                            DropdownMenuItem<Priority?>(
                              value: null,
                              child: Text('All Priorities'),
                            ),
                            ...Priority.values.map(
                              (priority) => DropdownMenuItem<Priority>(
                                value: priority,
                                child: Text(
                                  priority.toString().split('.').last,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child:
                        tasks.isEmpty
                            ? Center(
                              child: Text(
                                'No tasks yet. Add one using the + button!',
                              ),
                            )
                            : RefreshIndicator(
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
                                    onDismissed: (direction) {
                                      context.read<ItemBloc>().add(
                                        DeleteItem(task.id!),
                                      );
                                    },
                                    background: Container(
                                      color: Colors.red,
                                      alignment: Alignment.centerRight,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                      ),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: TaskListItem(
                                      task: task,
                                      onToggleStatus: () {
                                        final updatedTask = Item(
                                          id: task.id,
                                          name: task.name,
                                          description: task.description,
                                          status:
                                              task.status == Status.completed
                                                  ? Status.notCompleted
                                                  : Status.completed,
                                          createdAt: task.createdAt,
                                          priority: task.priority,
                                        );
                                        context.read<ItemBloc>().add(
                                          UpdateItem(task.id!, updatedTask),
                                        );
                                      },
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
                              ),
                            ),
                  ),
                ],
              );
            } else if (state is ItemError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return Center(child: Text('Press the + button to add a task!'));
          },
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled:
                  true,
              builder: (BuildContext context) {
                return AddTaskBottomSheet();
              },
            );
          },
          child: Icon(Icons.add),
          tooltip: 'Add Task',
        ),
      ),
    );
  }
}
