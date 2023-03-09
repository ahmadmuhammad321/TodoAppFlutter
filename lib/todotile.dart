import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class tile extends StatelessWidget {
  final String taskname;
  final String date;
  final bool isdone;
  Function(bool?)? onChanged;
  Function(BuildContext?)? deletefunction;
  tile(
      {super.key,
      required this.taskname,
      required this.date,
      required this.isdone,
      required this.onChanged,
      required this.deletefunction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, top: 25, right: 25),
      child: Slidable(
        endActionPane: ActionPane(motion: StretchMotion(), children: [
          SlidableAction(
            onPressed: deletefunction,
            icon: Icons.delete,
            backgroundColor: Colors.red.shade300,
            borderRadius: BorderRadius.circular(12),
          )
        ]),
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: isdone,
                    onChanged: onChanged,
                    activeColor: Colors.brown,
                  ),
                  Text(
                    taskname,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        decoration: isdone ? TextDecoration.lineThrough : null),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              )
            ],
          ),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}
