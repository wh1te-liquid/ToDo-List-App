import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/domain/entity/group.dart';
import 'package:todo_list/domain/entity/task.dart';

class TasksWidgetModel extends ChangeNotifier {
  int groupIndex;
  late final Future<Box<Group>> _groupBox;
  Group? _group;

  Group? get group => _group;

  var _tasks = <Task>[];

  List<Task> get tasks => _tasks.toList();

  TasksWidgetModel({required this.groupIndex}) {
    _setup();
  }

  void deleteTask(int taskIndex) {
    _group?.tasks?.deleteFromHive(taskIndex);
    _group?.save();
  }

  void doneToggle(int taskIndex) async {
    final task = _group?.tasks?[taskIndex];
    final currentState = task?.isDone ?? false;
    task?.isDone = !currentState;
    task?.save();
    notifyListeners();
  }

  void deleteAllTasks() async {
    _group?.tasks?.deleteAllFromHive();
    _group?.save();
  }

  void _readTasks() {
    _tasks = _group?.tasks ?? <Task>[];
    notifyListeners();
  }

  void _setupListen() async {
    final box = await _groupBox;
    _readTasks();
    box.listenable(keys: [groupIndex]).addListener(_readTasks);
  }

  void showForm(BuildContext context) {
    Navigator.of(context)
        .pushNamed('/groups/tasks/form', arguments: groupIndex);
  }

  void _loadGroup() async {
    final box = await _groupBox;
    _group = box.get(groupIndex);
    notifyListeners();
  }

  void _setup() {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(TaskAdapter());
    }
    _groupBox = Hive.openBox<Group>('groups_box');
    Hive.openBox<Task>('tasks_box');
    _loadGroup();
    _setupListen();
  }
}

class TasksWidgetModelProvider extends InheritedNotifier {
  final TasksWidgetModel model;

  const TasksWidgetModelProvider({
    required this.model,
    Key? key,
    required Widget child,
  }) : super(key: key, child: child, notifier: model);

  static TasksWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TasksWidgetModelProvider>()
        ?.widget;
    return widget is TasksWidgetModelProvider ? widget : null;
  }

  static TasksWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TasksWidgetModelProvider>();
  }
}
