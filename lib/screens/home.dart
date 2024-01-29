import 'package:flutter/material.dart';
import 'package:todo_api/screens/add_todo.dart';
import 'package:todo_api/services/api_calls.dart';
import 'package:todo_api/utils/snackbars.dart';
import 'package:todo_api/widgets/todo_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List items = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ToDo List')),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: moveToAddPage, label: const Text('Add a Task')),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchTodos,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
                child: Text(
              'No items in list',
              style: Theme.of(context).textTheme.headlineMedium,
            )),
            child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final card = items[index] as Map;
                  return ToDoCard(
                      card: card,
                      deleteElementsById: deleteElementsById,
                      index: index,
                      moveToEditPage: moveToEditPage);
                }),
          ),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<void> moveToAddPage() async {
    final route = MaterialPageRoute(builder: (context) => AddToDoPage());
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodos();
  }

  Future<void> moveToEditPage(Map todo) async {
    final route =
        MaterialPageRoute(builder: (context) => AddToDoPage(todo: todo));
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodos();
  }

  Future<void> deleteElementsById(String id) async {
    final success = await ApiCalls.deleteById(id);
    if (success) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      // ignore: use_build_context_synchronously
      showFailMessage(context, "Deletion failed");
    }
  }

  Future<void> fetchTodos() async {
    final result = await ApiCalls.fetchTodos();
    if (result != null) {
      setState(() {
        items = result;
      });
    } else {}
    setState(() {
      isLoading = false;
    });
  }
}
