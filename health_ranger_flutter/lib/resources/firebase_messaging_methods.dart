import "dart:convert";

import 'package:firebase_messaging/firebase_messaging.dart';
import "package:http/http.dart" as http;
import "package:googleapis_auth/auth_io.dart" as auth;

class FirebaseMessagingMethods {
  final _firebaseMessaging = FirebaseMessaging.instance;

  static Future<String> getAccessToken() async {
    final serviceAccountJson = {};

    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging",
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );

    client.close();
    return credentials.accessToken.data;
  }

  static sendNotification(String deviceToken, String title, String body) async {
    final String serverAccessTokenKey = await getAccessToken();
    String endpointFirebaseCloudMessaging =
        "https://fcm.googleapis.com/v1/projects/healthranger-70dd2/messages:send";

    final Map<String, dynamic> message = {
      "message": {
        "token": deviceToken,
        "notification": {
          "title": title,
          "body": body,
        },
        "data": {},
      }
    };

    await http.post(
      Uri.parse(endpointFirebaseCloudMessaging),
      headers: <String, String>{
        "Content-Type": "application/json",
        "Authorization": "Bearer $serverAccessTokenKey",
      },
      body: jsonEncode(message),
    );
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();

    print("fCMToken $fCMToken");
  }
}
