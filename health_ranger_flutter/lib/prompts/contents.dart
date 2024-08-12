import 'package:health_ranger_flutter/models/alert.dart';
import 'package:health_ranger_flutter/models/question.dart';
import 'package:health_ranger_flutter/models/reminder.dart';

class PromptContent {
  static String getAlertContentFromNote(String note, List<Alert> alerts) {
    String allAlerts = "";
    if (alerts.isNotEmpty) {
      for (var i = 0; i < alerts.length; i++) {
        allAlerts += "${alerts[i].title} ,";
      }
    }
    return """You are a medical professional in a rural setup. Assume this is an ongoing call transcript: $note. 
    Create patient level and community level alerts, containing text description and also a true false value on whether
    it is a community/village level alert or a patient level alert. An alert is basically a message saying whether
    the patient should be careful about something or the community should be. Assume currently alerts already outputted are $allAlerts.
    Do NOT repeat the same alert multiple times. Do NOT raise more than 5 alerts in total.""";
  }

  static String getAlertContentFromPhoto(List<Alert> alerts) {
    String allAlerts = "";
    if (alerts.isNotEmpty) {
      for (var i = 0; i < alerts.length; i++) {
        allAlerts += "${alerts[i].title} ,";
      }
    }
    return """You are a medical professional in a rural setup. Assume this is a photo evidence of a patient with mumps. 
    Create patient level and community level alerts, containing text description and also a true false value on whether
    it is a community/village level alert or a patient level alert. An alert is basically a message saying whether
    the patient should be careful about something or the community should be. Assume currently alerts already outputted are $allAlerts.
    Do NOT repeat the same alert multiple times. Do NOT raise more than 5 alerts in total.""";
  }

  static String getReminderContentFromNote(
      String note, List<Reminder> reminders) {
    String allReminders = "";
    if (reminders.isNotEmpty) {
      for (var i = 0; i < reminders.length; i++) {
        allReminders += "${reminders[i].title} ,";
      }
    }
    return """You are a medical professional in a rural setup. Assume this is an ongoing call transcript: $note. 
    Create patient level reminder, containing text description. A reminder is basically a message saying what a
    patient do in the future strongly based on what the doctor has suggested like revisiting after few days or taking a vaccine in few weeks.
    Above examples are suggestive, does not need to be included in the response. Also assume the patient is of low literacy so
    include vital reminders that need to be repeated to the patient. Assume currently reminders already outputted are $allReminders.
    Do NOT repeat the same reminder multiple times. Do NOT trigger more than 5 reminders in total.""";
  }

  static String getQuestionContentFromNote(
      String note, List<Question> questions) {
    String allQuestions = "";
    if (questions.isNotEmpty) {
      for (var i = 0; i < questions.length; i++) {
        allQuestions += "${questions[i].title} ,";
      }
    }
    return """You are a medical professional in a rural setup. Assume this is an ongoing call transcript: $note. 
    Create questions to ask a patient, containing text description. A question is basically an investigative inquiry to do more
    primary research about patient's condition. It can be like asking about how long they are having some issues, changes in lifestyle etc.
    Above examples are suggestive, does not need to be included in the response. Also assume the patient is of low literacy so
    ask as many deep insightful questions as possible. Assume currently questions already outputted are $allQuestions.
    Do NOT repeat the same questions multiple times. Do NOT ask more than 5 questions in total.""";
  }

  static String getQuestionContentFromPhoto(List<Question> questions) {
    String allQuestions = "";
    if (questions.isNotEmpty) {
      for (var i = 0; i < questions.length; i++) {
        allQuestions += "${questions[i].title} ,";
      }
    }
    return """You are a medical professional in a rural setup. Assume this is a photo evidence of a patient with mumps.
    Create questions to ask a patient, containing text description. A question is basically an investigative inquiry to do more
    primary research about patient's condition. It can be like asking about how long they are having some issues, changes in lifestyle etc.
    Above examples are suggestive, does not need to be included in the response. Also assume the patient is of low literacy so
    ask as many deep insightful questions as possible. Assume currently questions already outputted are $allQuestions.
    Do NOT repeat the same questions multiple times. Do NOT ask more than 5 questions in total.""";
  }
}
