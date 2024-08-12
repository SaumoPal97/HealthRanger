import 'package:cloud_firestore/cloud_firestore.dart';

class Patient {
  final String pid;
  final String name;
  final String phone;
  final String address;
  final String? photoUrl;
  final String? overview;

  const Patient({
    required this.pid,
    required this.name,
    required this.phone,
    required this.address,
    this.photoUrl,
    this.overview,
  });

  static Patient fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Patient(
      pid: snapshot["pid"],
      name: snapshot["name"],
      phone: snapshot["phone"],
      address: snapshot["address"],
      photoUrl: snapshot["photoUrl"],
      overview: snapshot["overview"],
    );
  }

  Map<String, dynamic> toJson() => {
        "pid": pid,
        "name": name,
        "phone": phone,
        "address": address,
        "photoUrl": photoUrl,
        "overview": overview,
      };
}
