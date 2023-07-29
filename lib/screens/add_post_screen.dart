import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_app/models/user.dart';
import 'package:instagram_app/providers/user_providers.dart';
import 'package:instagram_app/resources/firestore_methods.dart';
import 'package:instagram_app/utils/colors.dart';
import 'package:instagram_app/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => AddPostScreenState();
}

class AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file; 
  final TextEditingController _descriptionController=TextEditingController();
  bool _Loading= false; 

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Post'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a Photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Cancel'),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void postImage(
    String uid,
    String username,
    String profImage,
  )async{
    setState(() {
      _Loading=true;
    });
    try{
    String res=await FirestoreMethods().uploadPost(_descriptionController.text, _file!, uid, username, profImage);
    if(res=="Success")
    showSnackBar("Successfully Posted", context);
    else{
      showSnackBar(res, context);
    }
    }
    catch(e){
      showSnackBar(e.toString(), context);
    }
    setState(() {
      _Loading=false;
      _file=null;
    });
  }
  
  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user=Provider.of<UserProvider>(context).getUser;
    return (_Loading)?Center(child: Container(child: LinearProgressIndicator(color: primaryColor,),padding: EdgeInsets.fromLTRB(20, 0, 20, 0),)):
    (_file == null)
        ? Center(
            child: IconButton(onPressed: () {
              _selectImage(context);
            }, icon: const Icon(Icons.upload)),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed:()=> Navigator.of(context).pop(),
              ),
              title: const Text('Post To'),
              centerTitle: false,
              actions: [
                TextButton(
                    onPressed: ()=>postImage(user.uid, user.username, user.photoUrl),
                    child: const Text(
                      'Post',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ))
              ],
            ),
            body: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.photoUrl),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Write a caption...',
                        border: InputBorder.none,
                      ),
                      maxLines: 8,
                      controller: _descriptionController,
                    ),
                  ),
                  SizedBox(
                    height: 45,
                    width: 45,
                    child: AspectRatio(
                      aspectRatio: 487 / 451,
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: 
                          MemoryImage(_file!),
                          fit: BoxFit.fill,
                          alignment: FractionalOffset.topCenter,
                        )),
                      ),
                    ),
                  ),
                  const Divider(),
                ],
              )
            ]),
          );
  }
}
