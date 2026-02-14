import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/todo_provider.dart';
import '../models/todo_model.dart';
import '../widgets/todo_tile.dart';

class EisenhowerScreen extends StatelessWidget {
  const EisenhowerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eisenhower Matrix', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          final todos = todoProvider.todos; // Apply group filter if needed

          final q1 = todos.where((t) => t.isImportant && t.isUrgent).toList();
          final q2 = todos.where((t) => t.isImportant && !t.isUrgent).toList();
          final q3 = todos.where((t) => !t.isImportant && t.isUrgent).toList();
          final q4 = todos.where((t) => !t.isImportant && !t.isUrgent).toList();

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _buildQuadrant(context, 'DO FIRST', 'Urgent & Important', Colors.red.shade50, Colors.red.shade700, q1),
                      _buildQuadrant(context, 'SCHEDULE', 'Important, Not Urgent', Colors.blue.shade50, Colors.blue.shade700, q2),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      _buildQuadrant(context, 'DELEGATE', 'Urgent, Not Important', Colors.orange.shade50, Colors.orange.shade700, q3),
                      _buildQuadrant(context, 'DELETE', 'Neither', Colors.grey.shade100, Colors.grey.shade600, q4),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuadrant(BuildContext context, String title, String subtitle, Color bgColor, Color accentColor, List<Todo> todos) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accentColor.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Icon(Icons.circle, size: 12, color: accentColor),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: accentColor,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: todos.isEmpty
              ? Center(child: Text('Empty', style: GoogleFonts.poppins(color: Colors.grey.shade400, fontStyle: FontStyle.italic)))
              : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                         BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                      dense: true,
                      title: Text(
                        todos[index].title,
                        style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Checkbox(
                        value: todos[index].isDone,
                        activeColor: accentColor,
                        shape: const CircleBorder(),
                        onChanged: (_) {
                          Provider.of<TodoProvider>(context, listen: false)
                              .toggleStatus(todos[index].id);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
