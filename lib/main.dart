import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myprofile/Screens/Dashboard.dart';
import 'package:myprofile/Screens/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kIsweb;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAzS-E2dbxMsqaP6Cib84N4auN6-Uyo2iw",
            appId: "1:369230450620:web:5e86796a703529866925b9",
            messagingSenderId: "369230450620",
            projectId: "myprofile-2150a")
    );
  }else{
    await Firebase.initializeApp();

  }
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






