import 'package:flutter/material.dart';
import 'package:todo_list/widgets/task_form/task_form_widget_model.dart';

class TaskFormWidget extends StatefulWidget {
  const TaskFormWidget({Key? key}) : super(key: key);

  @override
  State<TaskFormWidget> createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  TaskFormWidgetModel? _model;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_model == null) {
      final groupKey = ModalRoute.of(context)!.settings.arguments as int;
      _model = TaskFormWidgetModel(groupKey: groupKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TaskFormWidgetModelProvider(
      model: _model!,
      child: const _TaskFormWidgetBody(),
    );
  }
}

class _TaskFormWidgetBody extends StatelessWidget {
  const _TaskFormWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: const Text("Новая задача"),
        centerTitle: true,
        elevation: 0,
      ),
      body: const Center(
        child: Padding(padding: EdgeInsets.all(25), child: _TaskNameWidget()),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: () {
          TaskFormWidgetModelProvider.read(context)?.model.saveTask(context);
        },
        child: const Icon(
          Icons.save,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _TaskNameWidget extends StatelessWidget {
  const _TaskNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TaskFormWidgetModelProvider.read(context)?.model;
    return TextField(
      cursorColor: Colors.black26,
      onChanged: (value) => model!.taskText = value,
      onEditingComplete: () => model!.saveTask(context),
      autofocus: true,
      minLines: null,
      maxLines: null,
      expands: true,
      decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Текст задачи"),
    );
  }
}
