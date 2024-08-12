// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_ranger_flutter/screens/alerts_screen.dart';
import 'package:health_ranger_flutter/screens/patients_screen.dart';
import 'package:health_ranger_flutter/screens/village_screen.dart';

List<Widget> homeScreenItems = [
  const VillageScreen(),
  const PatientsScreen(),
  const AlertScreen(),
];
