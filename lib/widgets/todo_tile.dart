import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo_model.dart';
import '../providers/todo_provider.dart';
import '../services/gamification_service.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;

  const TodoTile({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Dismissible(
          key: Key(todo.id),
          background: Container(
            color: Colors.red.shade50,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: Icon(Icons.delete_outline, color: Colors.red.shade400),
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
                        .addTodo(todo.title);
                  },
                ),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          },
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: Transform.scale(
              scale: 1.2,
              child: Checkbox(
                value: todo.isDone,
                shape: const CircleBorder(),
                activeColor: Colors.deepPurple,
                side: BorderSide(color: Colors.deepPurple.shade200, width: 2),
                onChanged: (value) {
                  Provider.of<TodoProvider>(context, listen: false)
                      .toggleStatus(todo.id);
                  if (value == true) {
                    Provider.of<GamificationService>(context, listen: false).completeTask();
                  }
                },
              ),
            ),
            title: Text(
              todo.title,
              style: TextStyle(
                decoration: todo.isDone ? TextDecoration.lineThrough : null,
                color: todo.isDone ? Colors.grey.shade400 : Colors.grey.shade800,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: todo.isImportant || todo.isUrgent
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: todo.isUrgent ? Colors.red.shade50 : Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: todo.isUrgent ? Colors.red.shade200 : Colors.amber.shade200,
                    ),
                  ),
                  child: Text(
                    todo.isUrgent ? 'Urgent' : 'Important',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: todo.isUrgent ? Colors.red.shade700 : Colors.amber.shade800,
                    ),
                  ),
                )
              : null,
          ),
        ),
      ),
    );
  }
}
