import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:health_ranger_flutter/resources/firestore_methods.dart';
import 'package:health_ranger_flutter/utils/utils.dart';
import 'package:health_ranger_flutter/widgets/text_field_input.dart';

class AddNewPatient extends StatefulWidget {
  const AddNewPatient({super.key});

  @override
  State<AddNewPatient> createState() => _AddNewPatientState();
}

class _AddNewPatientState extends State<AddNewPatient> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
  }

  void addNewPatient() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // signup user using our authmethodds
    String res = await FireStoreMethods().addPatient(
      name: _nameController.text,
      phone: _phoneNumberController.text,
      address: _addressController.text,
      file: _image,
    );
    // if string returned is sucess, user has been created
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      if (context.mounted) {
        showSnackBar(context, res);
      }
    }
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
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
        title: const Text("Add New Patient"),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Container(),
              ),
              const SizedBox(
                height: 64,
              ),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                          backgroundColor: Colors.red,
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'https://i.stack.imgur.com/l60Hf.png'),
                          backgroundColor: Colors.red,
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Enter patient\'s name',
                textInputType: TextInputType.text,
                textEditingController: _nameController,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Enter patient\'s phone number',
                textInputType: TextInputType.number,
                textEditingController: _phoneNumberController,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Enter patient\'s address',
                textInputType: TextInputType.text,
                textEditingController: _addressController,
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: addNewPatient,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: ShapeDecoration(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: !_isLoading
                      ? Text(
                          'Add new patient',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        )
                      : CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
