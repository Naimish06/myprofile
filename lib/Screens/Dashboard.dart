import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myprofile/Bloc/DashboardBloc/dashboardbloc_bloc.dart';
import 'package:myprofile/Screens/EditDetailsScreen.dart';
import 'package:myprofile/Screens/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DashboardblocBloc dashboardblocBloc = DashboardblocBloc();
  String imagepath = "",
      name = "",
      email = "",
      education = "",
      hoby = "",
      skill = "";
  File? image;

  @override
  void initState() {
    super.initState();
    GetProfiledata();
    dashboardblocBloc.add(DashboardInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardblocBloc, DashboardblocState>(
      bloc: dashboardblocBloc,
      listenWhen: (previous, current) => current is DashboardActionState,
      buildWhen: (previous, current) => current is! DashboardActionState,
      listener: (context, state) {
        if (state is DashboardlogoutbtnClcickState) {
          Navigator.pushAndRemoveUntil<dynamic>(
              context,
              MaterialPageRoute<dynamic>(builder: (context) => LoginScreen()),
              (route) => false);
        } else if (state is DashboardEditbtnclickState) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => EditScreen()));
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case DashboardblocLoadingState:
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case DashBoardblocLoadedState:
            return Scaffold(
              appBar: AppBar(
                title: Text('My Profile'),
                actions: [
                  IconButton(
                      onPressed: () {
                        dashboardblocBloc.add(DashboardLogoutBtnClickEvent());
                      },
                      icon: Icon(Icons.login_outlined))
                ],
              ),
              body: Container(
                child: Card(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.grey),
                              child: (imagepath != null && imagepath != "")
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
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            'Name : ${name} ',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            'Email Address : ${email} ',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            'Education : ${education} ',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            'Hobby : ${hoby} ',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            'Skills : ${skill} ',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: ElevatedButton(
                            child: Text('Edit'),
                            onPressed: () {
                              dashboardblocBloc
                                  .add(DashboardEditBtnClickEvent());
                            },
                          ),
                        )
                      ],
                    ),
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

  Future<void> GetProfiledata() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    imagepath = sp.getString("imagepath").toString();
    name = sp.getString("name").toString();
    email = sp.getString("email").toString();
    education = sp.getString("education").toString();
    skill = sp.getString("skill").toString();
    hoby = sp.getString("hoby").toString();
    if (imagepath != null && imagepath != "") {
      image = File(imagepath);
    }
    setState(() {});
  }
}
