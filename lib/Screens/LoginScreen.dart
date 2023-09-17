import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myprofile/Bloc/LoginBloc/login_bloc.dart';
import 'package:myprofile/Screens/Dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginBloc loginBloc = LoginBloc();
  String email = "";
  String password = "";

  TextEditingController email_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  bool remember_btn = false;

  final RegExp emailRegex =
      RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

  @override
  void initState() {
    super.initState();
    checkEmailSave();
    if (email != "" && password != "") {
      remember_btn = true;
      loginBloc.add(LoginIntialEvent(email, password));
    } else {
      loginBloc.add(LoginIntialEvent("", ""));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      bloc: loginBloc,
      listenWhen: (previous, current) => current is LoginActionState,
      buildWhen: (previous, current) => current is! LoginActionState,
      listener: (context1, state) {
        if (state is LoginSucessState) {
          Navigator.pushAndRemoveUntil<dynamic>(
              context,
              MaterialPageRoute<dynamic>(builder: (context) => Dashboard()),
              (route) => false);
        } else if (state is LoginFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('User Name Or Password is Worng')));
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case LoginLodingState:
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case LoginLoadedState:
            return Scaffold(
              body: Center(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(color: Colors.lightBlueAccent),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
                        child: Center(
                          child: Text(
                            "Login.. ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 35,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                      child: TextField(
                        controller: email_controller,
                        decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.person)),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: TextField(
                        controller: password_controller,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.lock)),
                        obscureText: true,
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Checkbox(
                            value: remember_btn ? true : false,
                            onChanged: (value) {
                              if (remember_btn) {
                                remember_btn = false;
                              } else {
                                remember_btn = true;
                              }
                              setState(() {});
                            },
                          ),
                        ),
                        Text('Remember Me'),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (!emailRegex
                            .hasMatch(email_controller.text.toString())) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text('Please Enter valid Email Address')));
                        } else if (password_controller.text.length <= 6) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Please Enter More than 6 Digit Password ')));
                        } else {
                          SavemainAuthSave();
                          loginBloc.add(LoginbtnClickEvent(
                              email_controller.text.toString(),
                              password_controller.text.toString(),
                              remember_btn));
                        }
                      },
                      child: Text('Login'),
                    ),
                    Container(
                      child: TextButton(
                        child: Text('Google'),
                        onPressed: () {
                         final da= signinwithGoogle();
                         if(da !="" && da !=null){
                           loginBloc.add(LoginbtnClickEvent(
                               "naimishrafaliya8850@gmail.com",
                               "Naimish",
                               remember_btn));
                         }
                        },
                      ),
                      decoration: BoxDecoration(shape: BoxShape.rectangle),
                    )
                  ],
                ),
              ),
            );
          default:
            return SizedBox();
        }
      },
    );
  }

  signinwithGoogle() async{
    final GoogleSignInAccount? gUser=await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth=await gUser!.authentication;

    final credential=GoogleAuthProvider.credential(accessToken: gAuth.accessToken,idToken: gAuth.idToken);
    final da=await FirebaseAuth.instance.signInWithCredential(credential);
    print("$da");
    return da;
  }

  checkEmailSave() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    email = sp.getString("rem_email").toString();
    password = sp.getString("rem_pass").toString();
    email_controller.text = email;
    password_controller.text = password;
  }

  SavemainAuthSave() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("mainemail", "naimishrafaliya8850@gmail.com");
    sp.setString("mainpassword", "Naimish");
  }
}
