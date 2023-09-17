import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myprofile/Bloc/EditBloc/editbloc_bloc.dart';
import 'package:myprofile/Screens/Dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final EditblocBloc editblocBloc = EditblocBloc();
  TextEditingController name_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();
  TextEditingController hoby_controller = TextEditingController();
  TextEditingController education_controller = TextEditingController();
  TextEditingController skill_controller = TextEditingController();
  String imagepath = "";
  File? image;
  XFile? file;
  bool is_changes = false;

  final RegExp emailRegex =
      RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

  @override
  void initState() {
    super.initState();
    getProfile();
    editblocBloc.add(EditInitialEvent());
  }

  void pickimage() async {
    //Navigator.pop(context);
    ImagePicker imagepicker = ImagePicker();
    file = await imagepicker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = File(file!.path);
      imagepath = file!.path;
      setState(() {
        is_changes = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditblocBloc, EditblocState>(
      bloc: editblocBloc,
      listener: (context, state) {
        if (state is EditSaveState) {
          Navigator.pushAndRemoveUntil<dynamic>(
              context,
              MaterialPageRoute<dynamic>(builder: (context) => Dashboard()),
              (route) => false);
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case EditLoadingState:
            return WillPopScope(
              onWillPop: () async {
                if (is_changes) {
                  _showconfirmationDialog();
                } else {
                  Navigator.of(context).pop();
                }
                return false;
              },
              child: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          case EditLoadedState:
            return Scaffold(
              appBar: AppBar(
                title: Text('Edit Profile'),
                leading: IconButton(
                    onPressed: () {
                      if (is_changes) {
                        _showconfirmationDialog();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    icon: Icon(Icons.arrow_back)),
              ),
              body: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: InkWell(
                          child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.grey),
                              child: (image != null /*&& imagepath!=""*/)
                                  ? CircleAvatar(
                                      radius: 50,
                                      backgroundImage: FileImage(image!),
                                    )
                                  : Center(
                                      child: Text(
                                        "No Photo",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    )),
                          onTap: () {
                            pickimage();
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                        child: TextField(
                          controller: name_controller,
                          decoration: InputDecoration(
                              labelText: 'Name',
                              hintText: 'Name',
                              prefixIcon: Icon(Icons.person)),
                          onChanged: (value) {
                            is_changes = true;
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                        child: TextField(
                          controller: email_controller,
                          decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'Email',
                              prefixIcon: Icon(Icons.email)),
                          onChanged: (value) {
                            is_changes = true;
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                        child: TextField(
                          controller: education_controller,
                          decoration: InputDecoration(
                              labelText: 'Education',
                              hintText: 'Education',
                              prefixIcon: Icon(Icons.book_outlined)),
                          onChanged: (value) {
                            is_changes = true;
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                        child: TextField(
                          controller: hoby_controller,
                          decoration: InputDecoration(
                              labelText: 'Hobby',
                              hintText: 'Hobby',
                              prefixIcon: Icon(Icons.hourglass_bottom)),
                          onChanged: (value) {
                            is_changes = true;
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                        child: TextField(
                          controller: skill_controller,
                          decoration: InputDecoration(
                              labelText: 'Skills',
                              hintText: 'Skills',
                              prefixIcon: Icon(Icons.settings)),
                          onChanged: (value) {
                            is_changes = true;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: ElevatedButton(
                          child: Text('Save'),
                          onPressed: () {
                            //Navigator.push(context, MaterialPageRoute(builder: (context)=> EditScreen()));
                            if (email_controller.text.toString().isNotEmpty &&
                                !emailRegex.hasMatch(
                                    email_controller.text.toString())) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Enter valid Email Address')));
                            } else {
                              editblocBloc.add(EditSaveBtnClickEvent(
                                  imagepath,
                                  name_controller.text.toString(),
                                  email_controller.text.toString(),
                                  education_controller.text.toString(),
                                  skill_controller.text.toString(),
                                  hoby_controller.text.toString()));
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );

          default:
            return SizedBox();
        }
      },
    );
  }

  void _showconfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you want to back ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                        builder: (context) => Dashboard()),
                    (route) => false);
              },
              child: Text('Back'),
            ),
          ],
        );
      },
    );
  }

  Future<void> getProfile() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    imagepath = sp.getString("imagepath")!;
    name_controller.text = sp.getString("name")!;
    email_controller.text = sp.getString("email")!;
    education_controller.text = sp.getString("education")!;
    skill_controller.text = sp.getString("skill")!;
    hoby_controller.text = sp.getString("hoby")!;
    if (imagepath != null && imagepath != "") {
      image = File(imagepath);
    }
    setState(() {});
  }
}
