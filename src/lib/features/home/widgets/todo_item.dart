import 'package:flutter/material.dart';
import 'package:my_app/models/todo.dart';
import 'package:intl/intl.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final Function(String) onToggle;
  final Function(String) onDelete;

  const TodoItem({
    required this.todo,
    required this.onToggle,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) => onToggle(todo.id),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          DateFormat('MMM d, y - h:mm a').format(todo.createdAt),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => onDelete(todo.id),
        ),
      ),
    );
  }
}
