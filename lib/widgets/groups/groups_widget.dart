import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list/widgets/groups/groups_widget_model.dart';

class GroupsWidget extends StatefulWidget {
  const GroupsWidget({Key? key}) : super(key: key);

  @override
  State<GroupsWidget> createState() => _GroupsWidgetState();
}

class _GroupsWidgetState extends State<GroupsWidget> {
  final _model = GroupsWidgetModel();

  @override
  Widget build(BuildContext context) {
    return GroupsWidgetModelProvider(
        model: _model, child: const _GroupsWidgetBody());
  }
}

class _GroupsWidgetBody extends StatelessWidget {
  const _GroupsWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Группы",
                    style: TextStyle(fontSize: 24),
                  ),
                  Row(
                    children: [
                      IconButton(
                        splashRadius: 20,
                        iconSize: 30,
                        onPressed: () => GroupsWidgetModelProvider.read(context)
                            ?.model
                            .deleteAllGroups(),
                        icon: const Icon(Icons.delete_forever_outlined),
                      ),
                      IconButton(
                        splashRadius: 20,
                        iconSize: 30,
                        onPressed: () => GroupsWidgetModelProvider.read(context)
                            ?.model
                            .showForm(context),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Container(
                  color: Colors.grey,
                  width: double.infinity,
                  height: 1,
                )),
            const Expanded(child: _GroupListWidget())
          ],
        ),
      ),
    );
  }
}

class _GroupListWidget extends StatelessWidget {
  const _GroupListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupsCount =
        GroupsWidgetModelProvider.watch(context)?.model.groups.length ?? 0;
    return groupsCount > 0
        ? ListView.separated(
            itemBuilder: (context, index) {
              return _GroupListRowWidget(
                indexInList: index,
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(
                height: 3,
              );
            },
            itemCount: groupsCount)
        : const Center(child: Text("Здесь пусто"));
  }
}

class _GroupListRowWidget extends StatelessWidget {
  final int indexInList;

  const _GroupListRowWidget({Key? key, required this.indexInList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = GroupsWidgetModelProvider.read(context)!.model;
    final group = model.groups[indexInList];
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.3,
        children: [
          SlidableAction(
            onPressed: (context) => model.deleteGroup(indexInList),
            backgroundColor: Colors.blueGrey,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 30),
        title: Text(
          group.name,
        ),
        trailing: const Icon(
          Icons.chevron_right,
        ),
        onTap: () => model.showTasks(context, indexInList),
      ),
    );
  }
}
