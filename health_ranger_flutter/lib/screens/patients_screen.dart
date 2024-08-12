import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:health_ranger_flutter/models/patient.dart";
import "package:health_ranger_flutter/screens/add_new_patient.dart";
import "package:health_ranger_flutter/widgets/patient_tile.dart";

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Patient> patients = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

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
        body: Column(
          children: [
            Container(
              color: const Color(0xffF3EDF7),
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    child: const Icon(Icons.search),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        filled: false,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8),
                      ),
                      keyboardType: TextInputType.text,
                      obscureText: false,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AddNewPatient(),
                    )),
                    child: Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        color: Color(0xffE8DEF8),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      child: const Icon(Icons.add),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text("Patients", style: TextStyle(fontSize: 36)),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('patients')
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (ctx, index) {
                        final patient =
                            Patient.fromSnap(snapshot.data!.docs[index]);
                        return PatientTile(patient: patient);
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
