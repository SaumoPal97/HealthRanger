import 'package:flutter/material.dart';
import 'package:health_ranger_flutter/models/alert.dart';
import 'package:health_ranger_flutter/resources/firestore_methods.dart';
import 'package:health_ranger_flutter/resources/notification_service.dart';

class AlertTile extends StatelessWidget {
  final Alert alert;

  const AlertTile({
    super.key,
    required this.alert,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(alert.title),
      trailing: GestureDetector(
        onTap: () async {
          NotificationService().showNotification(
            title: '⚠️ Alert!!!!!',
            body: alert.title,
          );
          await FireStoreMethods().addAlert(
            alert: alert,
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 20.0),
          child: const Text("Raise alert", style: TextStyle(color: Colors.red)),
        ),
      ),
    );
  }
}
