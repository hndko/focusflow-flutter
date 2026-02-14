class Todo {
  final String id;
  final String title;
  bool isDone;
  final DateTime createdAt;
  final String? groupId;
  final bool isImportant;
  final bool isUrgent;

  Todo({
    required this.id,
    required this.title,
    this.isDone = false,
    required this.createdAt,
    this.groupId,
    this.isImportant = false,
    this.isUrgent = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone,
      'createdAt': createdAt.toIso8601String(),
      'groupId': groupId,
      'isImportant': isImportant,
      'isUrgent': isUrgent,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      isDone: map['isDone'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
      groupId: map['groupId'],
      isImportant: map['isImportant'] ?? false,
      isUrgent: map['isUrgent'] ?? false,
    );
  }
}
