import "package:flutter/material.dart";
import "package:health_ranger_flutter/models/note.dart";
import "package:intl/intl.dart";

class NoteCard extends StatelessWidget {
  final Note note;
  const NoteCard({super.key, required this.note});

  showEntry(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Call Summary'),
            children: <Widget>[
              SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: Text(note.entry),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "By ${note.author}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            DateFormat.yMMMd().format(note.date),
            style: const TextStyle(
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              showEntry(context);
            },
            child: Text(
              "See More",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          )
        ],
      ),
    ));
  }
}
