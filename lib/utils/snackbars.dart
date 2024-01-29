import 'package:flutter/material.dart';

void showFailMessage(BuildContext context, String message) {
  final snackbar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(
        fontSize: 20,
      ),
    ),
    backgroundColor: Colors.red,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

void showSuccessMessage(BuildContext context, String message) {
  final snackbar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(fontSize: 20),
    ),
    backgroundColor: Colors.green,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}
