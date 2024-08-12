import 'package:flutter/material.dart';
import 'package:health_ranger_flutter/models/reminder.dart';

class ReminderTile extends StatelessWidget {
  final Reminder reminder;
  final void Function(bool?) onChanged;

  const ReminderTile({
    super.key,
    required this.reminder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(reminder.title),
      leading: Checkbox(
        value: reminder.isDone,
        onChanged: onChanged,
      ),
      trailing: const Icon(Icons.delete),
    );
  }
}
