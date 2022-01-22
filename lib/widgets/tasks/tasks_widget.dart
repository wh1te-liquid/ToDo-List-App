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
      return TasksWidgetModelProvider(
          model: model, child: const TasksWidgetBody());
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}

class TasksWidgetBody extends StatefulWidget {
  const TasksWidgetBody({Key? key}) : super(key: key);

  @override
  State<TasksWidgetBody> createState() => _TasksWidgetBodyState();
}

class _TasksWidgetBodyState extends State<TasksWidgetBody> {
  bool isHiden = false;

  @override
  Widget build(BuildContext context) {
    final model = TasksWidgetModelProvider.watch(context)?.model;
    final title = model?.group?.name ?? "Задачи";
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),
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
            Container(
              color: Colors.grey,
              width: double.infinity,
              height: 1,
            ),
            Expanded(
              child: ListView(
                children: [
                  if (model!.tasks.isNotEmpty)
                    const _TaskListWidget(
                      isDoneList: false,
                    ),
                  if (model.tasks.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text("Пока тут совсем пусто..."),
                      ),
                    ),
                  if (model.tasks.where((element) => element.isDone).isNotEmpty)
                    ListTile(
                      onTap: () => setState(() {
                        isHiden = !isHiden;
                      }),
                      title: const Text(
                        "Завершенные задачи",
                        style: TextStyle(fontSize: 17),
                      ),
                      trailing: Icon(isHiden
                          ? Icons.arrow_drop_down
                          : Icons.arrow_drop_up),
                    ),
                  if (isHiden == false)
                    const _TaskListWidget(
                      isDoneList: true,
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _TaskListWidget extends StatelessWidget {
  final bool isDoneList;

  const _TaskListWidget({Key? key, required this.isDoneList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int groupsCount =
        TasksWidgetModelProvider.watch(context)?.model.tasks.length ?? 0;
    return Column(
      children: List.generate(
        groupsCount,
        (index) =>
            TasksWidgetModelProvider.read(context)!.model.tasks[index].isDone ==
                    isDoneList
                ? _TaskListRowWidget(
                    indexInList: index,
                  )
                : Container(),
      ),
    );
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
    final style = task.isDone
        ? const TextStyle(decoration: TextDecoration.lineThrough)
        : null;
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.3,
        children: [
          SlidableAction(
            onPressed: (context) => model.deleteTask(indexInList),
            backgroundColor: task.isDone ? Colors.blueGrey : Colors.blueAccent,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 30),
        onTap: () => model.doneToggle(indexInList),
        leading: Container(
          clipBehavior: Clip.hardEdge,
          height: 23,
          width: 23,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: task.isDone
                ? Colors.blueGrey
                    .withOpacity((indexInList + 1) / model.tasks.length)
                : Colors.blueAccent
                    .withOpacity((indexInList + 1) / model.tasks.length),
          ),
        ),
        title: Text(
          task.text,
          style: style,
        ),
        trailing: Container(
          clipBehavior: Clip.hardEdge,
          height: 23,
          width: 23,
          decoration: BoxDecoration(
              shape: BoxShape.circle, border: Border.all(color: Colors.black)),
          child: task.isDone
              ? const Icon(
                  Icons.done,
                  color: Colors.black,
                  size: 18,
                )
              : null,
        ),
      ),
    );
  }
}
