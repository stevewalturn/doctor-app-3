import 'package:flutter/material.dart';
import 'package:my_app/ui/common/app_colors.dart';

class TodoInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;
  final bool isLoading;

  const TodoInput({
    Key? key,
    required this.controller,
    required this.onSubmit,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Add a new todo...',
                border: InputBorder.none,
              ),
              onSubmitted: (_) => onSubmit(),
            ),
          ),
          IconButton(
            icon: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(kcPrimaryColor),
                    ),
                  )
                : const Icon(Icons.add_circle, color: kcPrimaryColor),
            onPressed: isLoading ? null : onSubmit,
          ),
        ],
      ),
    );
  }
}
