import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:health_ranger_flutter/models/alert.dart';
import 'package:health_ranger_flutter/models/question.dart';
import 'package:health_ranger_flutter/models/reminder.dart';
import 'package:health_ranger_flutter/prompts/contents.dart';
import 'package:health_ranger_flutter/prompts/structures.dart';

class GeminiService {
  final apiKey = dotenv.env['GOOGLE_API_KEY'];

  Future<String?> generateContentFromAudio(Uint8List audioBytes) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey!,
    );

    final content = [
      Content.multi(
        [
          TextPart('Transcribe the audio'),
          DataPart("audio/wav", audioBytes),
        ],
      )
    ];
    final response = await model.generateContent(content);
    String? textResponse = response.text;
    return textResponse;
  }

  Future<List<Alert>> generateAlertsFromNotes(
      String note, List<Alert> alerts) async {
    final model = GenerativeModel(
        model: 'gemini-1.5-pro',
        apiKey: apiKey!,
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
          responseSchema: PromptStructures.alertSchema,
        ));

    final prompt = PromptContent.getAlertContentFromNote(note, alerts);
    final response = await model.generateContent([Content.text(prompt)]);
    String? textResponse = response.text;
    List<Alert> finalAlerts = [];

    if (textResponse != null) {
      final finalResponse = jsonDecode(textResponse);
      if (finalResponse.isNotEmpty) {
        for (var i = 0; i < finalResponse.length; i++) {
          finalAlerts.add(Alert.fromJson(finalResponse[i]));
        }
      }
    }

    return finalAlerts;
  }

  Future<List<Alert>> generateAlertsFromPhoto(
      Uint8List imageBytes, List<Alert> alerts) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-pro',
      apiKey: apiKey!,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: PromptStructures.alertSchema,
      ),
    );

    final prompt = PromptContent.getAlertContentFromPhoto(alerts);
    final response = await model.generateContent([
      Content.multi([
        TextPart(prompt),
        DataPart('image/jpeg', imageBytes),
      ])
    ]);
    String? textResponse = response.text;
    List<Alert> finalAlerts = [];

    if (textResponse != null) {
      final finalResponse = jsonDecode(textResponse);
      if (finalResponse.isNotEmpty) {
        for (var i = 0; i < finalResponse.length; i++) {
          finalAlerts.add(Alert.fromJson(finalResponse[i]));
        }
      }
    }

    return finalAlerts;
  }

  Future<List<Reminder>> generateRemindersFromNotes(
      String note, List<Reminder> reminders, String pid) async {
    final model = GenerativeModel(
        model: 'gemini-1.5-pro',
        apiKey: apiKey!,
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
          responseSchema: PromptStructures.reminderSchema,
        ));

    final prompt = PromptContent.getReminderContentFromNote(note, reminders);
    final response = await model.generateContent([Content.text(prompt)]);
    String? textResponse = response.text;
    List<Reminder> finalReminders = [];

    if (textResponse != null) {
      final finalResponse = jsonDecode(textResponse);
      if (finalResponse.isNotEmpty) {
        for (var i = 0; i < finalResponse.length; i++) {
          finalReminders.add(Reminder.fromJson(finalResponse[i], pid));
        }
      }
    }

    return finalReminders;
  }

  Future<List<Question>> generateQuestionsFromNotes(
      String note, List<Question> questions) async {
    final model = GenerativeModel(
        model: 'gemini-1.5-pro',
        apiKey: apiKey!,
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
          responseSchema: PromptStructures.questionSchema,
        ));

    final prompt = PromptContent.getQuestionContentFromNote(note, questions);
    final response = await model.generateContent([Content.text(prompt)]);
    String? textResponse = response.text;
    List<Question> finalQuestions = [];

    if (textResponse != null) {
      final finalResponse = jsonDecode(textResponse);
      if (finalResponse.isNotEmpty) {
        for (var i = 0; i < finalResponse.length; i++) {
          finalQuestions.add(Question.fromJson(finalResponse[i]));
        }
      }
    }

    return finalQuestions;
  }

  Future<List<Question>> generateQuestionsFromPhoto(
      Uint8List imageBytes, List<Question> questions) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-pro',
      apiKey: apiKey!,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: PromptStructures.questionSchema,
      ),
    );

    final prompt = PromptContent.getQuestionContentFromPhoto(questions);
    final response = await model.generateContent([
      Content.multi([
        TextPart(prompt),
        DataPart('image/jpeg', imageBytes),
      ])
    ]);
    String? textResponse = response.text;
    List<Question> finalQuestions = [];

    if (textResponse != null) {
      final finalResponse = jsonDecode(textResponse);
      if (finalResponse.isNotEmpty) {
        for (var i = 0; i < finalResponse.length; i++) {
          finalQuestions.add(Question.fromJson(finalResponse[i]));
        }
      }
    }

    return finalQuestions;
  }
}
