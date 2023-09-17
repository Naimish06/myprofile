import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myprofile/Screens/Dashboard.dart';
import 'package:myprofile/Screens/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyAPP());
}

class MyAPP extends StatelessWidget {
  const MyAPP({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String email="",password="",user_id="";

  @override
  void initState(){
    super.initState();
    user_loginDetails();
    Timer(Duration(seconds: 3), () {
      if(user_id != "" && user_id !=null && user_id !="null") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
      }else{
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image(image: AssetImage("asset/splash_logo.png"),
        width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.5,
        ),
      ),
    );
  }

  user_loginDetails() async{
    final SharedPreferences sp = await SharedPreferences.getInstance();
    if(user_id !=null){
      user_id =sp.getString("user_id").toString();
    }
    print("login $user_id");

  }
}






