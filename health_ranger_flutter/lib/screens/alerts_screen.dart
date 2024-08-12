import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:health_ranger_flutter/models/alert.dart";
import "package:health_ranger_flutter/widgets/alert_notif.dart";

class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(2.0),
                child: Container(
                  color: Colors.grey,
                  height: 2.0,
                )),
            title: const Row(
              children: [
                Icon(Icons.sunny),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Welcome to Malgudi", style: TextStyle(fontSize: 20)),
                    Text("Temp: 26ᵒC", style: TextStyle(fontSize: 10)),
                  ],
                ),
              ],
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text("English", style: TextStyle(fontSize: 15)),
                    Text("Change",
                        style: TextStyle(fontSize: 10, color: Colors.blue)),
                  ],
                ),
              ),
            ],
          ),
          body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                const Text("Alerts", style: TextStyle(fontSize: 36)),
                Expanded(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("alerts")
                          .doc("village")
                          .collection('alerts')
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (ctx, index) {
                            final alert =
                                Alert.fromSnap(snapshot.data!.docs[index]);
                            return AlertNotif(alert: alert);
                          },
                        );
                      }),
                ),
                Expanded(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("alerts")
                          .doc("patient")
                          .collection('alerts')
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (ctx, index) {
                            final alert =
                                Alert.fromSnap(snapshot.data!.docs[index]);
                            return AlertNotif(alert: alert);
                          },
                        );
                      }),
                ),
              ]))),
    );
  }
}
