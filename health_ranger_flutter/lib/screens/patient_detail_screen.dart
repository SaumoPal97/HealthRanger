import "package:cloud_firestore/cloud_firestore.dart";
import "package:floating_action_bubble/floating_action_bubble.dart";
import "package:flutter/material.dart";
import "package:health_ranger_flutter/models/note.dart";
import "package:health_ranger_flutter/models/patient.dart";
import "package:health_ranger_flutter/models/reminder.dart";
import "package:health_ranger_flutter/screens/patient_bot.dart";
import "package:health_ranger_flutter/screens/patient_chw.dart";
import "package:health_ranger_flutter/screens/patient_scribe.dart";
import "package:health_ranger_flutter/widgets/note_card.dart";
import "package:health_ranger_flutter/widgets/reminder_tile.dart";

class PatientDetailScreen extends StatefulWidget {
  final Patient patient;
  const PatientDetailScreen({super.key, required this.patient});

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(2.0),
                child: Container(
                  color: Colors.grey,
                  height: 2.0,
                )),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Center(
              child: Column(
                children: [
                  Text(
                    widget.patient.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.patient.phone,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.transparent,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ]),
        body: SafeArea(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Overview",
                    style: TextStyle(fontSize: 36),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('patients')
                        .doc(widget.patient.pid)
                        .get(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError)
                        return Center(
                          heightFactor: 0.5,
                          child: Text(snapshot.hasError.toString()),
                        );
                      return snapshot.hasData
                          ? SingleChildScrollView(
                              child: SizedBox(
                                height: 200,
                                child: Text(
                                  "${snapshot.data!['overview']}",
                                ),
                              ),
                            )
                          : Container();
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Call History",
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 120,
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("patients")
                                  .doc(widget.patient.pid)
                                  .collection('notes')
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<
                                          QuerySnapshot<Map<String, dynamic>>>
                                      snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (ctx, index) {
                                    final note = Note.fromSnap(
                                        snapshot.data!.docs[index]);
                                    return NoteCard(note: note);
                                  },
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Reminders",
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("patients")
                            .doc(widget.patient.pid)
                            .collection('reminders')
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
                              final reminder =
                                  Reminder.fromSnap(snapshot.data!.docs[index]);
                              return ReminderTile(
                                reminder: reminder,
                                onChanged: (value) {},
                              );
                            },
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionBubble(
          // Menu items
          items: <Bubble>[
            // Floating action menu item
            Bubble(
              title: "Join as CHW",
              iconColor: Theme.of(context).colorScheme.onPrimary,
              bubbleColor: Theme.of(context).colorScheme.primary,
              icon: Icons.call,
              titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                _animationController.reverse();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      PatientChwScreen(patient: widget.patient),
                ));
              },
            ),
            // Floating action menu item
            Bubble(
              title: "Join as Scribe",
              iconColor: Theme.of(context).colorScheme.onPrimary,
              bubbleColor: Theme.of(context).colorScheme.primary,
              icon: Icons.transcribe,
              titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                _animationController.reverse();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PatientScribeScreen(
                    patient: widget.patient,
                  ),
                ));
              },
            ),
            //Floating action menu item
            Bubble(
              title: "Join as AI",
              iconColor: Theme.of(context).colorScheme.onPrimary,
              bubbleColor: Theme.of(context).colorScheme.primary,
              icon: Icons.smart_toy,
              titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                _animationController.reverse();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PatientBotScreen(
                    patient: widget.patient,
                  ),
                ));
              },
            ),
          ],
          animation: _animation,
          onPress: () => _animationController.isCompleted
              ? _animationController.reverse()
              : _animationController.forward(),
          iconData: Icons.call,
          iconColor: Theme.of(context).colorScheme.onPrimary,
          backGroundColor: Theme.of(context).colorScheme.primary,
        ));
  }
}
