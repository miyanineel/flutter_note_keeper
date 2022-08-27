import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({Key? key}) : super(key: key);

  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  TextEditingController controller = TextEditingController();
  CollectionReference firestore =
      FirebaseFirestore.instance.collection("noteData");
  final addSnackbar = const SnackBar(content: Text('Note Added'));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Note"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                TextField(
                  controller: controller,
                  cursorColor: Colors.greenAccent,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.greenAccent,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Colors.greenAccent,
                      child: const Text("Cancel"),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        dataAdd().then((value) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(addSnackbar);
                        });
                      },
                      color: Colors.greenAccent,
                      child: const Text("Save"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> dataAdd() async {
    Map<String, dynamic> data = {
      "data": controller.text,
      // controller.text
    };
    // firestore.add(data);
    // firestore.doc("hello");
    firestore.doc().set(data);
    Navigator.pop(context);
  }
}
