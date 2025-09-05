import 'package:flutter/material.dart';

class GoalSettingDialog extends StatefulWidget {
  const GoalSettingDialog({super.key});

  @override
  State<GoalSettingDialog> createState() => _GoalSettingDialogState();
}

class _GoalSettingDialogState extends State<GoalSettingDialog> {
  final _goalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set Weekly Goals'),
      content: TextField(
        controller: _goalController,
        decoration: const InputDecoration(
          labelText: 'Your goal for this week',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(_goalController.text.trim());
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

