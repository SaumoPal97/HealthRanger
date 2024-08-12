import "package:flutter/material.dart";

class VillageInfoCard extends StatelessWidget {
  final String title;
  final String? details;
  final IconData icon;
  final Widget widget;
  const VillageInfoCard({
    super.key,
    required this.title,
    required this.icon,
    required this.widget,
    this.details,
  });

  showCardDetails(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Summary'),
            children: <Widget>[
              SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: Text(details!),
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
      child: GestureDetector(
        onTap: () => details != null ? showCardDetails(context) : null,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width * 0.45,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [Text(title), Icon(icon)],
              ),
              widget
            ],
          ),
        ),
      ),
    );
  }
}
