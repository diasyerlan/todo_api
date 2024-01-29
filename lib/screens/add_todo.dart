import 'package:flutter/material.dart';
import 'package:todo_api/services/api_calls.dart';
import 'package:todo_api/utils/snackbars.dart';

// ignore: must_be_immutable
class AddToDoPage extends StatefulWidget {
  @override
  State<AddToDoPage> createState() => _AddToDoPageState();
  Map? todo;
  AddToDoPage({super.key, this.todo});
}

class _AddToDoPageState extends State<AddToDoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final desc = todo['description'];
      titleController.text = title;
      descriptionController.text = desc;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isEdit
            ? const Text('Add Todo Task')
            : const Text('Edit Todo Task'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Description'),
            minLines: 5,
            maxLines: 8,
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: !isEdit ? submitData : updateData,
              child: !isEdit ? const Text('Submit') : const Text('Update'))
        ],
      ),
    );
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      showFailMessage(context, "Something went wrong!");
      return;
    }
    final id = todo['_id'];

    final success = await ApiCalls.updateTodo(id, body);
    if (success) {
      // ignore: use_build_context_synchronously
      showSuccessMessage(context, "Updation successful");
    } else {
      // ignore: use_build_context_synchronously
      showFailMessage(context, "Updation failed");
    }
  }

  Future<void> submitData() async {
    final success = await ApiCalls.submitTodo(body);
    if (success) {
      // ignore: use_build_context_synchronously
      showSuccessMessage(context, 'Submition successful');
      titleController.text = '';
      descriptionController.text = '';
    } else {
      // ignore: use_build_context_synchronously
      showFailMessage(context, "Submission failed");
    }
  }

  Map get body {
    final title = titleController.text;
    final desc = descriptionController.text;
    return {"title": title, "description": desc, "is_completed": false};
  }
}
