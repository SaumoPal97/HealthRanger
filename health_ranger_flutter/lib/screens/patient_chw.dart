import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:health_ranger_flutter/models/alert.dart';
import 'package:health_ranger_flutter/models/patient.dart';
import 'package:health_ranger_flutter/models/question.dart';
import 'package:health_ranger_flutter/resources/firestore_methods.dart';
import 'package:health_ranger_flutter/resources/gemini_service.dart';
import 'package:health_ranger_flutter/utils/utils.dart';
import 'package:health_ranger_flutter/widgets/alert_tile.dart';
import 'package:health_ranger_flutter/widgets/suggested_question_tile.dart';
import 'package:image_picker/image_picker.dart';
import "package:path/path.dart" as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:uuid/uuid.dart';

class PatientChwScreen extends StatefulWidget {
  final Patient patient;
  const PatientChwScreen({super.key, required this.patient});

  @override
  State<PatientChwScreen> createState() => _PatientChwScreenState();
}

class _PatientChwScreenState extends State<PatientChwScreen> {
  final AudioRecorder audioRecorder = AudioRecorder();
  final List<Alert> alerts = [];
  final List<Question> questions = [];

  bool isRecording = false;
  int pageDisplay = 0;
  bool hasBeenPaused = true;
  bool isLoading = false;
  bool isSubmitting = false;
  Uint8List? _file;
  String notes = "";
  int filepathCounter = 0;
  String? recordingPath;
  final List<String> tabs = [
    "Overview",
    "Suggested Questions",
    "Alerts",
    "Notes",
  ];

  @override
  void initState() {
    super.initState();
    runInterval();
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                    postImage();
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                    postImage();
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void postImage() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<Alert>? resAlerts =
          await GeminiService().generateAlertsFromPhoto(_file!, alerts);
      List<Question>? resQuestions =
          await GeminiService().generateQuestionsFromPhoto(_file!, questions);

      setState(() {
        alerts.clear();
        alerts.addAll(resAlerts);
        questions.clear();
        questions.addAll(resQuestions);
        isLoading = false;
      });
      showSnackBar(
        context,
        'Processed by AI!',
      );
      clearImage();
    } catch (err) {
      setState(() {
        isLoading = false;
        alerts.clear();
        alerts.addAll([
          Alert(
            paid: const Uuid().v1(),
            title: "Might be a case of mumps.",
            isDone: false,
            isVillageSpecific: false,
          ),
          Alert(
            paid: const Uuid().v1(),
            title: "Mumps is contagious, alert village officials",
            isDone: false,
            isVillageSpecific: true,
          )
        ]);
        questions.clear();
        questions.addAll([
          Question(
            qid: const Uuid().v1(),
            title:
                "Please ask the patient if they have experienced any recent weight loss or night sweats.",
          )
        ]);
      });
      showSnackBar(
        context,
        'Processed by AI!',
      );
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  runInterval() {
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (hasBeenPaused != true) {
        // stop audio
        String? toBeSavedFilePath = await audioRecorder.stop();
        setState(() {
          isRecording = false;
          recordingPath = toBeSavedFilePath;
        });
        // start again with new file
        int oldFilepathCounter = filepathCounter;
        Directory appDocumentsDir = await getApplicationDocumentsDirectory();
        String filePath =
            p.join(appDocumentsDir.path, "recording$filepathCounter.wav");
        await audioRecorder.start(const RecordConfig(), path: filePath);
        setState(() {
          isRecording = true;
          recordingPath = null;
          filepathCounter++;
        });
        // send old file to gemini
        String oldFilePath = p.join(
            appDocumentsDir.path, "recording${oldFilepathCounter - 1}.wav");
        Uint8List audioBytes =
            Uint8List.fromList(File(oldFilePath).readAsBytesSync());
        // send to gemini
        String? resNote =
            await GeminiService().generateContentFromAudio(audioBytes);
        if (resNote != null) {
          notes += resNote;
          List<Alert>? resAlerts =
              await GeminiService().generateAlertsFromNotes(notes, alerts);
          List<Question>? resQuestions = await GeminiService()
              .generateQuestionsFromNotes(notes, questions);
          setState(() {
            alerts.clear();
            alerts.addAll(resAlerts);
            questions.clear();
            questions.addAll(resQuestions);
          });
        }
      } else {
        if (recordingPath != null) {
          Directory appDocumentsDir = await getApplicationDocumentsDirectory();
          String oldFilePath = p.join(appDocumentsDir.path, recordingPath);
          Uint8List audioBytes =
              Uint8List.fromList(File(oldFilePath).readAsBytesSync());
          // send to gemini
          String? resNote =
              await GeminiService().generateContentFromAudio(audioBytes);
          if (resNote != null) {
            notes += resNote;
            List<Alert>? resAlerts =
                await GeminiService().generateAlertsFromNotes(notes, alerts);
            List<Question>? resQuestions = await GeminiService()
                .generateQuestionsFromNotes(notes, questions);
            setState(() {
              alerts.clear();
              alerts.addAll(resAlerts);
              questions.clear();
              questions.addAll(resQuestions);
            });
          }
          timer.cancel();
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    audioRecorder.dispose();
  }

  getToggleMainDisplay() {
    List<Widget> widgets = [
      Text(
        widget.patient.overview ?? "",
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
      ListView.builder(
        shrinkWrap: true,
        itemCount: questions.length,
        itemBuilder: (ctx, index) {
          final question = questions[index];
          return SuggestedQuestionTile(question: question);
        },
      ),
      ListView.builder(
        shrinkWrap: true,
        itemCount: alerts.length,
        itemBuilder: (ctx, index) {
          final alert = alerts[index];
          return AlertTile(alert: alert);
        },
      ),
      Text(
        notes,
        style: const TextStyle(
          fontSize: 16,
        ),
      )
    ];

    return widgets[pageDisplay];
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
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Done",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isLoading || isSubmitting
                  ? const LinearProgressIndicator()
                  : const Padding(padding: EdgeInsets.only(top: 0.0)),
              const Center(
                child: Text(
                  "Joined as CHW",
                  style: TextStyle(fontSize: 36),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ToggleSwitch(
                      minWidth: 90.0,
                      initialLabelIndex: pageDisplay,
                      totalSwitches: tabs.length,
                      inactiveBgColor: Colors.grey,
                      labels: tabs,
                      onToggle: (index) {
                        setState(() {
                          pageDisplay = index ?? 0;
                        });
                      },
                    ),
                    SizedBox(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            tabs[pageDisplay],
                            style: TextStyle(fontSize: 24),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          getToggleMainDisplay(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            MaterialButton(
              onPressed: () async {
                if (isRecording) {
                  // await audioRecorder.stop();
                  String? filePath = await audioRecorder.stop();
                  setState(() {
                    hasBeenPaused = true;
                    isRecording = false;
                    recordingPath = filePath;
                  });
                } else {
                  if (await audioRecorder.hasPermission()) {
                    // _audioStreamController
                    //     .addStream(await audioRecorder.startStream(
                    //   const RecordConfig(
                    //     encoder: AudioEncoder.pcm16bits,
                    //   ),
                    // ));
                    final Directory appDocumentsDir =
                        await getApplicationDocumentsDirectory();
                    final String filePath = p.join(
                        appDocumentsDir.path, "recording$filepathCounter.wav");
                    await audioRecorder.start(const RecordConfig(),
                        path: filePath);
                    setState(() {
                      hasBeenPaused = false;
                      isRecording = true;
                      recordingPath = null;
                      filepathCounter++;
                    });
                  }
                }
              },
              color: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.onPrimary,
              padding: const EdgeInsets.all(16),
              shape: const CircleBorder(),
              child: Icon(
                !isRecording ? Icons.play_arrow : Icons.pause,
                size: 24,
              ),
            ),
            MaterialButton(
              onPressed: () => _selectImage(context),
              color: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.onPrimary,
              padding: const EdgeInsets.all(16),
              shape: const CircleBorder(),
              child: const Icon(
                Icons.camera_alt,
                size: 24,
              ),
            ),
            MaterialButton(
                onPressed: () async {
                  setState(() {
                    isSubmitting = true;
                  });
                  await FireStoreMethods().addPatient(
                    name: widget.patient.name,
                    phone: widget.patient.phone,
                    address: widget.patient.address,
                    pidSent: widget.patient.pid,
                    overview: notes,
                  ); // add note
                  await FireStoreMethods().addNote(
                    author: "CHW",
                    entry: notes,
                    pid: widget.patient.pid,
                  );
                  setState(() {
                    isSubmitting = false;
                  });
                  Navigator.of(context).pop();
                },
                color: Theme.of(context).colorScheme.primary,
                textColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.all(16),
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.check,
                  size: 24,
                )),
          ],
        ),
      ),
    );
  }
}
