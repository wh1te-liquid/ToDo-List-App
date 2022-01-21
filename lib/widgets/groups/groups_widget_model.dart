import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/domain/entity/group.dart';
import 'package:todo_list/domain/entity/task.dart';

class GroupsWidgetModel extends ChangeNotifier {
  GroupsWidgetModel() {
    _setup();
  }

  var _groups = <Group>[];

  List<Group> get groups => _groups.toList();

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed('/groups/form');
  }

  void showTasks(BuildContext context, int groupIndex) async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    final box = await Hive.openBox<Group>('groups_box');
    final groupKey = box.keyAt(groupIndex) as int;

    Navigator.of(context).pushNamed('/groups/tasks', arguments: groupKey);
  }

  void _readGroupsFromBox(Box<Group> box) {
    _groups = box.values.toList();
    notifyListeners();
  }

  void deleteGroup(int groupIndex) async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    final box = await Hive.openBox<Group>('groups_box');
    box.getAt(groupIndex)?.tasks?.deleteAllFromHive();
    await box.deleteAt(groupIndex);
  }

  void deleteAllGroups() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    final box = await Hive.openBox<Group>('groups_box');
    for (final group in box.values) {
      group.tasks?.deleteAllFromHive();
    }
    await box.deleteAll(box.keys);
  }

  void _setup() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    final box = await Hive.openBox<Group>('groups_box');
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(TaskAdapter());
    }
    await Hive.openBox<Task>('tasks_box');
    _readGroupsFromBox(box);
    box.listenable().addListener(() async{
      _readGroupsFromBox(box);
    });
  }
}

class GroupsWidgetModelProvider extends InheritedNotifier {
  final GroupsWidgetModel model;

  const GroupsWidgetModelProvider({
    required this.model,
    Key? key,
    required Widget child,
  }) : super(key: key, child: child, notifier: model);

  static GroupsWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<GroupsWidgetModelProvider>()
        ?.widget;
    return widget is GroupsWidgetModelProvider ? widget : null;
  }

  static GroupsWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupsWidgetModelProvider>();
  }
}
