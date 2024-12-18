import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/features/todo/models/todo_model.dart';
import 'package:my_app/ui/common/app_colors.dart';

class TodoItem extends StatelessWidget {
  final TodoModel todo;
  final Function(String) onToggle;
  final Function(String) onDelete;

  const TodoItem({
    Key? key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todo.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(todo.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          leading: Checkbox(
            value: todo.isCompleted,
            activeColor: kcPrimaryColor,
            onChanged: (_) => onToggle(todo.id),
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
              color: todo.isCompleted ? kcMediumGrey : kcDarkGreyColor,
            ),
          ),
          subtitle: Text(
            DateFormat('MMM d, y - h:mm a').format(todo.createdAt),
            style: const TextStyle(
              fontSize: 12,
              color: kcMediumGrey,
            ),
          ),
        ),
      ),
    );
  }
}
