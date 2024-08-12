import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:health_ranger_flutter/models/alert.dart';
import 'package:health_ranger_flutter/models/note.dart';
import 'package:health_ranger_flutter/models/patient.dart';
import 'package:health_ranger_flutter/models/reminder.dart';
import 'package:health_ranger_flutter/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // PATIENT STUFF
  Future<String> addPatient({
    required String name,
    required String phone,
    required String address,
    String? pidSent,
    String? overview,
    Uint8List? file,
  }) async {
    String res = "Some error Occurred";
    String photoUrl;
    Patient patient;
    try {
      if (name.isNotEmpty && phone.isNotEmpty && address.isNotEmpty) {
        String pid = pidSent ?? const Uuid().v1();

        if (file != null) {
          photoUrl =
              await StorageMethods().uploadImageToStorage('profilePics', file);

          patient = Patient(
            pid: pid,
            name: name,
            phone: phone,
            address: address,
            photoUrl: photoUrl,
            overview: overview ?? "",
          );
        } else {
          patient = Patient(
            name: name,
            phone: phone,
            address: address,
            pid: pid,
            overview: overview ?? "",
          );
        }

        // adding user in our database
        await _firestore.collection("patients").doc(pid).set(patient.toJson());

        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // NOTES STUFF
  Future<String> addNote({
    required String author,
    required String entry,
    required String pid,
  }) async {
    String res = "Some error Occurred";
    Note note;
    try {
      if (author.isNotEmpty && entry.isNotEmpty && pid.isNotEmpty) {
        String nid = const Uuid().v1();

        note = Note(
          nid: nid,
          pid: pid,
          author: author,
          entry: entry,
          date: DateTime.now(),
        );

        // adding user in our database
        await _firestore
            .collection("patients")
            .doc(pid)
            .collection("notes")
            .doc(nid)
            .set(note.toJson());

        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // REMINDERS STUFF
  Future<String> addReminders({
    required List<Reminder> reminders,
  }) async {
    String res = "Some error Occurred";
    try {
      for (var i = 0; i < reminders.length; i++) {
        await _firestore
            .collection("patients")
            .doc(reminders[i].pid)
            .collection("reminders")
            .doc(reminders[i].rid)
            .set(reminders[i].toJson());
      }

      res = "success";
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // ALERTS STUFF
  Future<String> addAlert({
    required Alert alert,
  }) async {
    String res = "Some error Occurred";
    try {
      await _firestore
          .collection("alerts")
          .doc(alert.isVillageSpecific ? "village" : "patient")
          .collection("alerts")
          .doc(alert.paid)
          .set(alert.toJson());

      res = "success";
    } catch (err) {
      return err.toString();
    }
    return res;
  }
}
