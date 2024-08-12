import "package:flutter/material.dart";
import "package:health_ranger_flutter/models/task.dart";
import "package:health_ranger_flutter/widgets/radial_gauge.dart";
import "package:health_ranger_flutter/widgets/task_tile.dart";
import "package:health_ranger_flutter/widgets/village_info_card.dart";
import "package:uuid/uuid.dart";

class VillageScreen extends StatefulWidget {
  const VillageScreen({super.key});

  @override
  State<VillageScreen> createState() => _VillageScreenState();
}

class _VillageScreenState extends State<VillageScreen> {
  final tasks = [
    Task(
      tid: const Uuid().v1(),
      title: "Survey residents for new outbreak of dengue",
      isDone: false,
    ),
    Task(
      tid: const Uuid().v1(),
      title: "Get local waterbodies cleaned",
      isDone: false,
    ),
    Task(
      tid: const Uuid().v1(),
      title: "Send reminders for vaccination doses for kids under 5",
      isDone: false,
    ),
    Task(
      tid: const Uuid().v1(),
      title: "Contact medical experts for new kind of flu outbreak",
      isDone: false,
    )
  ];

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
                const Text("Village Overview", style: TextStyle(fontSize: 36)),
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    VillageInfoCard(
                      title: "Population",
                      icon: Icons.people,
                      widget: Text("10.7k", style: TextStyle(fontSize: 48)),
                    ),
                    VillageInfoCard(
                      title: "Surveyed",
                      icon: Icons.check_box_outlined,
                      widget: Text("9.5k", style: TextStyle(fontSize: 48)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    VillageInfoCard(
                      title: "Health",
                      details:
                          "The recent heavy rains have severely impacted the healthcare of the villagers. Stagnant water has become a breeding ground for mosquitoes, leading to a spike in dengue cases. The increase in mosquito populations has heightened the risk of other vector-borne diseases as well. The already limited healthcare resources are now strained, as the community grapples with this health crisis. Villagers are facing increased anxiety and discomfort due to the growing threat, and the situation demands urgent attention to prevent further escalation of health problems.",
                      icon: Icons.health_and_safety_rounded,
                      widget: RadialGauge(value: 70, color: Colors.red),
                    ),
                    VillageInfoCard(
                      title: "Morale",
                      details:
                          "Regular surveys, checkup calls, and improved medical care have significantly boosted village morale. These initiatives foster a sense of care and connection, ensuring that health issues are addressed promptly. The community feels supported and valued, leading to greater trust, well-being, and overall happiness in the village.",
                      icon: Icons.mood,
                      widget: RadialGauge(value: 85, color: Colors.green),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text("Tasks (Suggested by AI)",
                    style: TextStyle(fontSize: 24)),
                Expanded(
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (ctx, index) {
                      final task = tasks[index];
                      return TaskTile(
                        title: task.title,
                        isDone: task.isDone,
                        onChanged: (value) {
                          // Implement task completion logic
                        },
                      );
                    },
                  ),
                ),
              ]))),
    );
  }
}
