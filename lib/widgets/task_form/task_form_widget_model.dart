import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_list/domain/entity/group.dart';
import 'package:todo_list/domain/entity/task.dart';

class TaskFormWidgetModel {
  String taskText = "";
  int groupKey;

  TaskFormWidgetModel({required this.groupKey});

  void saveTask(BuildContext context) async {
    if (taskText.isEmpty) return;
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(TaskAdapter());
    }
    final tasksBox = await Hive.openBox<Task>('tasks_box');
    final task = Task(text: taskText, isDone: false);
    await tasksBox.add(task);
    
    final groupBox = await Hive.openBox<Group>('groups_box');
    final group = groupBox.get(groupKey);
    group?.addTask(tasksBox, task);
    Navigator.pop(context);
  }
}

class TaskFormWidgetModelProvider extends InheritedWidget {
  final TaskFormWidgetModel model;

  const TaskFormWidgetModelProvider({
    required this.model,
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  static TaskFormWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TaskFormWidgetModelProvider>()
        ?.widget;
    return widget is TaskFormWidgetModelProvider ? widget : null;
  }

  static TaskFormWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TaskFormWidgetModelProvider>();
  }

  @override
  bool updateShouldNotify(TaskFormWidgetModelProvider oldWidget) {
    return false;
  }
}