// each and every call

import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String nid;
  final String pid;
  final String author;
  final DateTime date;
  final String entry;

  const Note({
    required this.nid,
    required this.pid,
    required this.author,
    required this.date,
    required this.entry,
  });

  static Note fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Note(
      nid: snapshot["nid"],
      pid: snapshot["pid"],
      author: snapshot["author"],
      date: snapshot["date"].toDate(),
      entry: snapshot["entry"],
    );
  }

  Map<String, dynamic> toJson() => {
        "nid": nid,
        "pid": pid,
        "author": author,
        "date": date,
        "entry": entry,
      };
}
