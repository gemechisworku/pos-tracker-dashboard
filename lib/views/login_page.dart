// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pos_tracker/firebase_options.dart';
import 'package:pos_tracker/views/route_user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  User? thisUser;
  String loginSubmitText = 'Login';
  String forgotPwdText = 'Forgot password?';
  String headerText = 'Please login to continue';

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<FirebaseApp> _initializeFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();

    FirebaseApp firebaseApp = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return firebaseApp;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _loginScreen();
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  TextFormField _textFormField(controller, labelString, hideText) {
    return TextFormField(
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: labelString,
      ),
      onSaved: (value) {
        controller.text = value!;
      },
      controller: controller,
      obscureText: hideText,
    );
  }

  final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.white,
    primary: Colors.blue,
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
    ),
  );

  Widget _loginScreen() {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: Material(
              // color: Colors.transparent,
              child: SizedBox(
                height: 80,
                width: 150,
                child: InkWell(
                  child: Image.asset('assets/images/postms.png'),
                  onTap: () {},
                ),
              ),
            ),
          ),
          Row(
            children: [
              Text(
                headerText,
                style: TextStyle(fontSize: 20.0),
                textAlign: TextAlign.start,
              ),
            ],
          ),
          SizedBox(height: 30.0),
          _textFormField(emailController, 'Email', false),
          if (headerText == 'Please login to continue')
            _textFormField(passwordController, 'Password', true),
          SizedBox(height: 30.0),
          Row(
            children: [
              ElevatedButton(
                style: buttonStyle,
                onPressed: () async {
                  if (loginSubmitText == 'Login') {
                    _login(
                        emailController.text, passwordController.text, context);
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) =>
                    //         FilterAccess(thisUser: thisUser!)));
                    print('Login email: ${thisUser!.email}');
                  }
                },
                child: Text(loginSubmitText),
              ),
              SizedBox(width: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey[300],
                  onPrimary: Colors.black,
                ),
                child: Text(forgotPwdText),
                onPressed: () {
                  setState(() {
                    if (forgotPwdText == 'Forgot password?') {
                      forgotPwdText = 'Remember password?';
                      loginSubmitText = 'Submit';
                      headerText = 'Submit your email to restore your password';
                    } else {
                      forgotPwdText = 'Forgot password?';
                      loginSubmitText = 'Login';
                      headerText = 'Please login to continue';
                    }
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  _login(email, pwd, context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pwd);
      User? user = userCredential.user!;
      setState(() {
        thisUser = user;
        // print('the logged in user email: ${thisUser!.email}');
      });
      print('the logged in user email: ${thisUser!.email}');
      // SharedPreferences sharedP = await SharedPreferences.getInstance();
      // sharedP.setString('userEmail', email);
      // sharedP.setString('userId', thisUser.uid);

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => UserRouter(thisUser: thisUser!)));
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      _showDialog(context,
          'Wrong email or password. Please try again with a correct credential!');
    }
  }

  Future<dynamic> _showDialog(BuildContext context, msg) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirmation'),
        content: Text(msg),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Ok'),
          ),
        ],
      ),
    );
  }
}
