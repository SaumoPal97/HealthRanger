import 'package:flutter/material.dart';
import 'package:health_ranger_flutter/models/alert.dart';

class AlertNotif extends StatelessWidget {
  final Alert alert;

  const AlertNotif({
    super.key,
    required this.alert,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: Border(
        bottom: BorderSide(),
      ),
      leading: alert.isVillageSpecific ? Icon(Icons.home) : Icon(Icons.people),
      title: Text(alert.title),
    );
  }
}
