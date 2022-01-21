import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_list/domain/entity/group.dart';

class GroupFormWidgetModel {
  String groupName = "";

  void saveGroup(BuildContext context) async {
    if (groupName.isEmpty) return;
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    final box = await Hive.openBox<Group>('groups_box');
    final group = Group(name: groupName);
    await box.add(group);
    Navigator.pop(context);
  }
}

class GroupFormWidgetModelProvider extends InheritedWidget {
  final GroupFormWidgetModel model;

  const GroupFormWidgetModelProvider({
    required this.model,
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  static GroupFormWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<GroupFormWidgetModelProvider>()
        ?.widget;
    return widget is GroupFormWidgetModelProvider ? widget : null;
  }

  static GroupFormWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupFormWidgetModelProvider>();
  }

  @override
  bool updateShouldNotify(GroupFormWidgetModelProvider oldWidget) {
    return true;
  }
}
