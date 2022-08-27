import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'add_note_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference firestore =
      FirebaseFirestore.instance.collection("noteData");
  TextEditingController updateNoteController = TextEditingController();
  final deleteSnackbar = const SnackBar(content: Text('Note Deleted'));
  final updateSnackbar = const SnackBar(content: Text('Note Updated'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: firestore.snapshots(),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index];
                      return ListTile(
                        leading: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Update Note"),
                                content: TextField(
                                  controller: updateNoteController,
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
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Navigator.of(context).pop();
                                      data.reference.update({
                                        "data": updateNoteController.text,
                                      }).then((value) {
                                        Navigator.of(context).pop();
                                      }).then((value) {
                                        updateNoteController.clear();
                                      }).then((value) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(updateSnackbar);
                                      });
                                    },
                                    child: const Text("Update"),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        title: Text(
                          data['data'].toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            data.reference.delete().then((value) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(deleteSnackbar);
                            });
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      );
                    },
                  );
            // if (snapshot.hasData) {
            // return ListView.builder(
            //   itemCount: snapshot.data!.size,
            //   itemBuilder: (BuildContext context, int index) {
            //     return ListTile(
            //       title: Text("${snapshot.data![index]['']}"),
            //     );
            //   },
            // );
            // return ListView(
            //     children: snapshot.data!.docs.map(
            //   (document) {
            //     return ListTile(
            //       title: Text(document['data']),
            //       trailing: IconButton(
            //         onPressed: () {},
            //         icon: Icon(Icons.delete),
            //       ),
            //
            //       // trailing: Icon(Icons.delete),
            //     );
            //   },
            // ).toList());
            // }
            // return Center(
            //   child: CircularProgressIndicator(),
            // );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNotePage()),
          );
        },
        elevation: 0.0,
        backgroundColor: Colors.greenAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
