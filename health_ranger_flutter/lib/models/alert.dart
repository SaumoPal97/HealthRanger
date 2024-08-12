// generated by docs + chws + AI

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Alert {
  final String paid;
  final String title;
  final bool isDone;
  final bool isVillageSpecific;

  const Alert({
    required this.paid,
    required this.title,
    required this.isDone,
    required this.isVillageSpecific,
  });

  static Alert fromJson(Map json) {
    return Alert(
      paid: const Uuid().v1(),
      title: json["title"],
      isDone: false,
      isVillageSpecific: json["isVillageSpecific"],
    );
  }

  static Alert fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Alert(
      paid: snapshot["paid"],
      title: snapshot["title"],
      isDone: snapshot["isDone"],
      isVillageSpecific: snapshot["isVillageSpecific"],
    );
  }

  Map<String, dynamic> toJson() => {
        "paid": paid,
        "title": title,
        "isDone": isDone,
        "isVillageSpecific": isVillageSpecific,
      };
}
