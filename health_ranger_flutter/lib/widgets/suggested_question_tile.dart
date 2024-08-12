import 'package:flutter/material.dart';
import 'package:health_ranger_flutter/models/question.dart';

class SuggestedQuestionTile extends StatelessWidget {
  final Question question;

  const SuggestedQuestionTile({
    super.key,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(question.title),
      leading: const Icon(
        Icons.chevron_right,
      ),
    );
  }
}
