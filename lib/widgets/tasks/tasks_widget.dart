import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list/widgets/tasks/tasks_widget_model.dart';

class TasksWidget extends StatefulWidget {
  const TasksWidget({Key? key}) : super(key: key);

  @override
  _TasksWidgetState createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  TasksWidgetModel? _model;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_model == null) {
      final groupKey = ModalRoute.of(context)!.settings.arguments as int;
      _model = TasksWidgetModel(groupIndex: groupKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = _model;
    if (model != null) {
      return TasksWidgetModelProvider(model: model, child: const TasksWidgetBody());
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}

class TasksWidgetBody extends StatelessWidget {
  const TasksWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TasksWidgetModelProvider.watch(context)?.model;
    final title = model?.group?.name ?? "Задачи";
    return Scaffold(
      body: SafeArea(child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                Row(
                  children: [
                     IconButton(
                      splashRadius: 20,
                      iconSize: 30,
                      onPressed: () => model?.deleteAllTasks(),
                      icon: const Icon(Icons.delete_forever_outlined),
                    ),
                    IconButton(
                      splashRadius: 20,
                      iconSize: 30,
                      onPressed: () => model?.showForm(context),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(color: Colors.grey,width: double.infinity, height: 1,),
          const Expanded(child: _TaskListWidget())
        ],
      ),),
    );
  }
}

class _TaskListWidget extends StatelessWidget {
  const _TaskListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupsCount =
        TasksWidgetModelProvider.watch(context)?.model.tasks.length ?? 0;
    return groupsCount > 0
        ? ListView.separated(
        itemBuilder: (context, index) {
          return _TaskListRowWidget(
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

class _TaskListRowWidget extends StatelessWidget {
  final int indexInList;

  const _TaskListRowWidget({Key? key, required this.indexInList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TasksWidgetModelProvider.read(context)!.model;
    final task = model.tasks[indexInList];
    final style = task.isDone ? const TextStyle(decoration: TextDecoration.lineThrough) : null;
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.3,
        children: [
          SlidableAction(
            onPressed: (context) => model.deleteTask(indexInList),
            backgroundColor: Colors.blueGrey,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 30),
        onTap: () => model.doneToggle(indexInList),
        title: Text(
          task.text,
          style: style,
        ),
        trailing:  Container(
          clipBehavior: Clip.hardEdge,
          height: 23,
          width: 23,
          decoration: BoxDecoration(shape: BoxShape.circle, border:  Border.all(color: Colors.black)),
          child: task.isDone ? const Icon(
            Icons.done,
            color: Colors.black,
            size: 20,
          ) : null,
        ),
      ),
    );
  }
}

