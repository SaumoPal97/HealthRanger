import 'package:google_generative_ai/google_generative_ai.dart';

class PromptStructures {
  static final alertSchema = Schema.array(
    description: 'List of alerts',
    items: Schema.object(properties: {
      'title': Schema.string(
        description: "detailed 1-liner about the alert in less than 25 words.",
        nullable: false,
      ),
      'isVillageSpecific': Schema.boolean(
        description:
            "whether it is a community/village centric alert or a patient level alert",
        nullable: false,
      )
    }, requiredProperties: [
      'title',
      'isVillageSpecific'
    ]),
  );

  static final reminderSchema = Schema.array(
    description: 'List of reminders',
    items: Schema.object(properties: {
      'title': Schema.string(
        description:
            "detailed 1-liner about the reminder in less than 25 words.",
        nullable: false,
      ),
    }, requiredProperties: [
      'title',
    ]),
  );

  static final questionSchema = Schema.array(
    description: 'List of questions',
    items: Schema.object(properties: {
      'title': Schema.string(
        description:
            "detailed 1-liner about the question in less than 25 words. try ending with a question mark.",
        nullable: false,
      ),
    }, requiredProperties: [
      'title',
    ]),
  );
}
