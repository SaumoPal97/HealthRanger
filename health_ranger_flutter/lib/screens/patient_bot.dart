import 'package:flutter/material.dart';
import 'package:health_ranger_flutter/models/patient.dart';
import 'package:health_ranger_flutter/widgets/text_field_input.dart';

class PatientBotScreen extends StatefulWidget {
  final Patient patient;
  const PatientBotScreen({super.key, required this.patient});

  @override
  State<PatientBotScreen> createState() => _PatientBotScreenState();
}

class _PatientBotScreenState extends State<PatientBotScreen> {
  final TextEditingController _additionalDetailController =
      TextEditingController();

  bool isLoading = false;
  bool isSubmitting = false;

  @override
  void dispose() {
    super.dispose();
    _additionalDetailController.dispose();
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
                  "Joined as AI",
                  style: TextStyle(fontSize: 36),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldInput(
                hintText:
                    'Enter additional information to discuss with ${widget.patient.name}',
                textInputType: TextInputType.multiline,
                textEditingController: _additionalDetailController,
                isMultiline: true,
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
                  setState(() {
                    isSubmitting = true;
                  });
                  // call twilio bot caller
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
