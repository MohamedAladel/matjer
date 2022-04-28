// ignore: file_names
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:matjer/Database.dart';
// ignore: library_prefixes
import 'package:path/path.dart' as Path;

import 'Post.dart';

// ignore: must_be_immutable
class AddPostPage extends StatefulWidget {
  String? path;
  String showT = "";
  File? file;
  UploadTask? task;
  String? imgurl;

  AddPostPage({Key? key}) : super(key: key);
  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();

  void saveData() {
    String url;
    if (widget.imgurl == null) {
      url = "";
    } else {
      url = widget.imgurl!;
    }

    Post temp = Post(
        titleController.text, descController.text, priceController.text, url);
    temp.setId(savePost(temp));
    return;
  }

  Future uploadfiles() async {
    if (widget.file == null) return;
    final filename = Path.basename(widget.file!.path);
    final destination = 'files/$filename';

    widget.task = FirebaseApi.uploadFile(destination, widget.file!)!;
    if (widget.task == null) return;

    final snapshot = await widget.task!.whenComplete(() => {});
    final urlLink = await snapshot.ref.getDownloadURL();

    widget.imgurl = urlLink;
    setState(() {
      widget.showT = urlLink;
    });
  }

  Future chooseFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;

    final path = result.files.single.path;
    setState(() {
      widget.showT = path!;
      widget.file = File(path);
    });
    uploadfiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add a prodect")),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              cursorRadius: const Radius.circular(20),
              decoration: const InputDecoration(
                labelText: "Enter the title",
              ),
              controller: titleController,
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              cursorRadius: const Radius.circular(20),
              decoration: const InputDecoration(
                labelText: "Enter the describtion",
              ),
              controller: descController,
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              keyboardType: TextInputType.number,
              cursorRadius: const Radius.circular(20),
              decoration: const InputDecoration(
                labelText: "Enter the Price",
              ),
              controller: priceController,
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 30, 0, 2),
          ),
          ElevatedButton(
            onPressed: () => saveData(),
            child: SizedBox(
              width: 180,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("publish", style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
            // padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            // color: Colors.green,
            // textColor: Colors.white,
            // elevation: 5,
          ),
          ElevatedButton(
            onPressed: chooseFile,
            child: SizedBox(
              width: 180,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("upload a File", style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
          Text(widget.showT)
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    descController.dispose();
    priceController.dispose();
    titleController.dispose();
    super.dispose();
  }
}

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }
}
