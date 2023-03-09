import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_hive/database.dart';
import 'package:intl/intl.dart';
import 'todotile.dart';

class taskslist extends StatefulWidget {
  const taskslist({super.key});

  @override
  State<taskslist> createState() => _taskslistState();
}

class _taskslistState extends State<taskslist> {
  final textcontroller = TextEditingController();
  TextEditingController dateinput = TextEditingController();
  final Database db = Database();
  final mybox = Hive.box('mybox');
  @override
  void initState() {
    // TODO: implement initState
    if (mybox.get('TODOLIST') == null) {
      db.createInitialdata();
    } else {
      db.loadData();
    }
    dateinput.text = "";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown.shade400,
        title: Text('To Do List'),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade300,
      body: ListView.builder(
        itemCount: db.todolist.length,
        itemBuilder: (context, index) {
          return tile(
            taskname: db.todolist[index][0],
            isdone: db.todolist[index][1],
            date: db.todolist[index][2],
            onChanged: (value) => checkboxchanged(value, index),
            deletefunction: (context) => deletetask(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addtask,
        child: Icon(Icons.add),
        backgroundColor: Colors.brown.shade400,
      ),
    );
  }

  void checkboxchanged(bool? val, int index) {
    setState(() {
      db.todolist[index][1] = !db.todolist[index][1];
    });
    db.updateData();
  }

  void addtask() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: Container(
              height: 200,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextField(
                      controller: textcontroller,
                      decoration: InputDecoration(
                          hintText: 'Add a new task',
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                    TextField(
                      controller:
                          dateinput, //editing controller of this TextField
                      decoration: InputDecoration(
                          icon: Icon(Icons.calendar_today), //icon of text field
                          labelText: "Select Date" //label text of field
                          ),
                      readOnly:
                          true, //set it true, so that user will not able to edit text
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(
                                2000), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2101));

                        if (pickedDate != null) {
                          print(
                              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          print(
                              formattedDate); //formatted date output using intl package =>  2021-03-16
                          //you can implement different kind of Date Format here according to your requirement

                          setState(() {
                            dateinput.text =
                                formattedDate; //set output date to TextField value.
                          });
                        } else {
                          print("Date is not selected");
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MaterialButton(
                          onPressed: savetask,
                          child: Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.brown.shade400,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        MaterialButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.brown.shade400,
                        )
                      ],
                    )
                  ]),
            ),
          );
        });
  }

  void savetask() {
    setState(() {
      db.todolist.add([textcontroller.text, false, dateinput.text]);
      textcontroller.clear();
      dateinput.clear();
    });
    Navigator.of(context).pop();
    db.updateData();
  }

  void deletetask(int index) {
    setState(() {
      db.todolist.removeAt(index);
    });
    db.updateData();
  }
}
