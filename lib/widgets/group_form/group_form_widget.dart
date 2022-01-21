import 'package:flutter/material.dart';
import 'package:todo_list/widgets/group_form/group_form_widget_model.dart';

class GroupFormWidget extends StatefulWidget {
  const GroupFormWidget({Key? key}) : super(key: key);

  @override
  State<GroupFormWidget> createState() => _GroupFormWidgetState();
}

class _GroupFormWidgetState extends State<GroupFormWidget> {
  final _model = GroupFormWidgetModel();

  @override
  Widget build(BuildContext context) {
    return GroupFormWidgetModelProvider(
        model: _model, child: const _GroupFormWidgetBody());
  }
}

class _GroupFormWidgetBody extends StatelessWidget {
  const _GroupFormWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: const Text("Новая группа"),
        centerTitle: true,
        elevation: 0,
      ),
      body: const Center(
        child: Padding(padding: EdgeInsets.all(25), child: _GroupNameWidget()),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: () {
          GroupFormWidgetModelProvider.read(context)?.model.saveGroup(context);
        },
        child: const Icon(
          Icons.save,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _GroupNameWidget extends StatelessWidget {
  const _GroupNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = GroupFormWidgetModelProvider.read(context)?.model;
    return TextField(
      cursorColor: Colors.black26,
      onChanged: (value) => model!.groupName = value,
      onEditingComplete: () => model!.saveGroup(context),
      autofocus: true,
      decoration: const InputDecoration(
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          border: OutlineInputBorder(),
          hintText: "Имя группы"),
    );
  }
}
