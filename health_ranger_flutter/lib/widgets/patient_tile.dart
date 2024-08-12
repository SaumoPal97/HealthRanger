import 'package:flutter/material.dart';
import 'package:health_ranger_flutter/models/patient.dart';
import 'package:health_ranger_flutter/screens/patient_detail_screen.dart';
import 'package:random_avatar/random_avatar.dart';

class PatientTile extends StatelessWidget {
  final Patient patient;

  const PatientTile({
    super.key,
    required this.patient,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PatientDetailScreen(
              patient: patient,
            ),
          ),
        ),
        child: ListTile(
          title: Text(patient.name),
          leading: patient.photoUrl != null
              ? CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(
                    patient.photoUrl!,
                  ),
                  radius: 20,
                )
              : RandomAvatar(patient.name,
                  trBackground: true, height: 50, width: 50),
          trailing: const Icon(Icons.chevron_right),
          shape:
              const Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
        ),
      ),
    );
  }
}
