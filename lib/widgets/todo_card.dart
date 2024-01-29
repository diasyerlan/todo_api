import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ToDoCard extends StatelessWidget {
  int index;
  Map card;
  final Function(Map) moveToEditPage;
  final Function(String) deleteElementsById;

  ToDoCard(
      {super.key,
      required this.card,
      required this.deleteElementsById,
      required this.index,
      required this.moveToEditPage});

  @override
  Widget build(BuildContext context) {
    final id = card['_id'];
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text((index + 1).toString()),
        ),
        title: Text(card["title"]),
        subtitle: Text(card["description"]),
        trailing: PopupMenuButton(onSelected: (value) {
          if (value == 'edit') {
            moveToEditPage(card);
          } else if (value == 'delete') {
            deleteElementsById(id);
          }
        }, itemBuilder: (context) {
          return [
            const PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            )
          ];
        }),
      ),
    );
  }
}
