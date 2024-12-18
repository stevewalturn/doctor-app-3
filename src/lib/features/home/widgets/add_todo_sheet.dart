import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class AddTodoSheet extends StatelessWidget {
  final Function(SheetResponse<String>) completer;
  final SheetRequest request;

  const AddTodoSheet({
    required this.completer,
    required this.request,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add New Todo',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter todo title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => completer(SheetResponse(confirmed: false)),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  if (controller.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Todo title cannot be empty'),
                      ),
                    );
                    return;
                  }
                  completer(
                    SheetResponse(
                      confirmed: true,
                      data: controller.text.trim(),
                    ),
                  );
                },
                child: const Text('Add'),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
