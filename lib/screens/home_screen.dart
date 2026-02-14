import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/group_model.dart';
import '../providers/todo_provider.dart';
import '../widgets/todo_tile.dart';
import 'focus_screen.dart';
import 'eisenhower_screen.dart';
import '../services/gamification_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showAddTaskModal(BuildContext context) {
    final TextEditingController taskController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: taskController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'New Task',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                     if (value.isNotEmpty) {
                      Provider.of<TodoProvider>(context, listen: false)
                          .addTodo(value);
                      Navigator.pop(context);
                    }
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                       if (taskController.text.isNotEmpty) {
                         // Simple simulation of AI breakdown adding multiple tasks
                         final subtasks = [
                           'Research ${taskController.text}',
                           'Outline ${taskController.text}',
                           'Execute ${taskController.text}'
                         ];

                         for (var task in subtasks) {
                            Provider.of<TodoProvider>(context, listen: false).addTodo(task);
                         }
                         Navigator.pop(context);
                         ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(content: Text('AI generated 3 subtasks! 🤖')),
                         );
                       }
                    },
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('AI Breakdown'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (taskController.text.isNotEmpty) {
                        Provider.of<TodoProvider>(context, listen: false)
                            .addTodo(taskController.text);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Add Task'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showAddGroupModal(BuildContext context) {
    final TextEditingController groupController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Group'),
          content: TextField(
            controller: groupController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Group Name',
              hintText: 'e.g., Work, Personal',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (groupController.text.isNotEmpty) {
                  Provider.of<TodoProvider>(context, listen: false)
                      .addGroup(groupController.text, Icons.folder);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          final currentGroup = todoProvider.groups.firstWhere(
            (g) => g.id == todoProvider.selectedGroupId,
            orElse: () => Group(id: 'all', name: 'All Tasks', icon: Icons.list),
          );
          final title = todoProvider.selectedGroupId == null ? 'All Tasks' : currentGroup.name;

          return Row(
            children: [
              // Persistent Sidebar
              Container(
                width: 280,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(2, 0),
                    ),
                  ],
                  border: Border(right: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Column(
                  children: [
                    // Custom Header
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                         gradient: LinearGradient(
                          colors: [Colors.deepPurple.shade400, Colors.deepPurple.shade700],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Consumer<GamificationService>(
                        builder: (context, gameService, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.check_circle_outline, color: Colors.white, size: 32),
                                  const SizedBox(width: 12),
                                  Text(
                                    'FocusFlow',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Level ${gameService.level}',
                                        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        '${gameService.xp} XP',
                                        style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.local_fire_department, color: Colors.orange, size: 16),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${gameService.streak}',
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: (gameService.xp % (gameService.level * 100)) / (gameService.level * 100),
                                  backgroundColor: Colors.white24,
                                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                                  minHeight: 6,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        children: [
                          _buildNavItem(
                            context,
                            icon: Icons.list_alt,
                            title: 'All Tasks',
                            isSelected: todoProvider.selectedGroupId == null,
                            onTap: () => todoProvider.selectGroup(null),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                            child: Text(
                              'GROUPS',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade500,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          ...todoProvider.groups.map((group) {
                            return _buildNavItem(
                              context,
                              icon: group.icon,
                              title: group.name,
                              isSelected: todoProvider.selectedGroupId == group.id,
                              onTap: () => todoProvider.selectGroup(group.id),
                              onDelete: () {
                                 // Confirm delete dialog code...
                                 showDialog(context: context, builder: (ctx) => AlertDialog(
                                   title: const Text('Delete Group?'),
                                   content: const Text('This will delete all tasks in this group.'),
                                   actions: [
                                     TextButton(onPressed: ()=>Navigator.pop(ctx), child: const Text('Cancel')),
                                     TextButton(onPressed: (){
                                       todoProvider.deleteGroup(group.id);
                                       Navigator.pop(ctx);
                                     }, child: const Text('Delete', style: TextStyle(color: Colors.red))),
                                   ],
                                 ));
                              }
                            );
                          }),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.add, color: Colors.deepPurple.shade400, size: 20),
                            ),
                            title: Text(
                              'New Group',
                              style: GoogleFonts.poppins(
                                color: Colors.deepPurple.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () => _showAddGroupModal(context),
                          ),
                           Padding(
                            padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                            child: Text(
                              'TOOLS',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade500,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          _buildNavItem(
                            context,
                            icon: Icons.grid_view_rounded,
                            title: 'Eisenhower Matrix',
                            isSelected: false,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const EisenhowerScreen()),
                            ),
                          ),
                          _buildNavItem(
                            context,
                            icon: Icons.timer_rounded,
                            title: 'Focus Timer',
                            isSelected: false,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const FocusScreen()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content Area
              Expanded(
                child: Container(
                  color: Colors.grey.shade50, // Subtle background for content area
                  child: Column(
                    children: [
                      // Header inside content
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                        color: Colors.grey.shade50,
                        child: Row(
                          children: [
                            Text(
                              title,
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade900,
                              ),
                            ),
                            const Spacer(),

                          ],
                        ),
                      ),

                      // Task List
                      Expanded(
                        child: todoProvider.todos.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(30),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.deepPurple.withOpacity(0.1),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      )
                                    ]
                                  ),
                                  child: Icon(
                                    Icons.spa_rounded,
                                    size: 80,
                                    color: Colors.deepPurple.shade200,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'Ready to Focus?',
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    color: Colors.grey.shade800,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Create a task to get started',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            itemCount: todoProvider.todos.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: TodoTile(todo: todoProvider.todos[index]),
                              );
                            },
                          ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskModal(context),
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, {
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    VoidCallback? onDelete,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.deepPurple.shade50 : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: onTap,
        leading: Icon(
          icon,
          color: isSelected ? Colors.deepPurple : Colors.grey.shade600,
          size: 22,
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.deepPurple.shade700 : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
        trailing: onDelete != null
            ? IconButton(
                icon: Icon(Icons.close, size: 16, color: Colors.grey.shade400),
                onPressed: onDelete,
              )
            : null,
      ),
    );
  }
}
