import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo_model.dart';
import '../providers/todo_provider.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;

  const TodoTile({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todo.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<TodoProvider>(context, listen: false).deleteTodo(todo.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${todo.title} deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                Provider.of<TodoProvider>(context, listen: false)
                    .addTodo(todo.title); // Simplification for undo
              },
            ),
          ),
        );
      },
      child: ListTile(
        leading: Checkbox(
          value: todo.isDone,
          onChanged: (value) {
            Provider.of<TodoProvider>(context, listen: false)
                .toggleStatus(todo.id);
          },
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
            color: todo.isDone ? Colors.grey : null,
          ),
        ),
      ),
    );
  }
}
