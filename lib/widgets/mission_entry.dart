import 'package:flutter/material.dart';
import 'package:patchai_test/classes/mission.dart';

class MissionEntry extends StatefulWidget {
  final Mission mission;

  MissionEntry({Key? key, required this.mission}) : super(key: key);

  @override
  _MissionEntryState createState() => _MissionEntryState();
}

class _MissionEntryState extends State<MissionEntry> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            widget.mission.missionName!,
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: 15),
          Text(
            widget.mission.details!,
            style: Theme.of(context).textTheme.bodyText2,
          )
        ],
      ),
    );
  }
}
