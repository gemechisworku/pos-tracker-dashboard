// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_build_context_synchronously, no_logic_in_create_state

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pos_tracker/db_services.dart';
import 'package:pos_tracker/model/user.dart';

class UserRegistration extends StatefulWidget {
  final List<String> userTypes;
 final MyUser myUser;
  const UserRegistration({Key? key, required this.userTypes, required this.myUser}) : super(key: key);
  @override
  _UserRegistrationState createState() => _UserRegistrationState(userTypes, myUser);
}

class _UserRegistrationState extends State<UserRegistration> {
  final List<String> userTypes;
  final MyUser myUser;
  _UserRegistrationState(this.userTypes, this.myUser);

  final usernameController = TextEditingController();
  final branchController = TextEditingController();
  final districtController = TextEditingController();
  final userTypeController = TextEditingController();
  final pwdController = TextEditingController();
  final emailController = TextEditingController();

  List<String> districts = [
    'Select district',
    'Adama',
    'Asella',
    'Bahirdar',
    'Central Finfine',
    'Chiro',
    'Dire Dawa',
    'Eastern Finfine',
    'Hawassa',
    'Hossana',
    'Jimma',
    'Nekemte',
    'North Finfine',
    'Shashemene',
    'South Finfine',
    'West Finfine'
  ];

  String _currentDistrict = 'Select district';
  String _currentType = 'Select workplace';

  @override
  void dispose() {
    usernameController.dispose();
    userTypeController.dispose();
    branchController.dispose();
    districtController.dispose();
    pwdController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: ListView(
          children: [
            _userTypesDropDown(),
            if (_currentType == 'District' || _currentType == 'Branch')
              _districtsDropDown(districts),
            if (_currentType == 'Branch')
              _textFormField(branchController, 'Branch Name'),
            _textFormField(usernameController, 'Username'),
            _textFormField(emailController, 'Email'),
            _textFormField(pwdController, 'Password'),
            SizedBox(
              height: 15.0,
            ),
            Row(
              children: [
                ElevatedButton(
                  style: registerPOSButton,
                  onPressed: () {
                    _createUser(
                      emailController.text,
                      pwdController.text,
                      usernameController.text,
                      _currentDistrict == 'Select district'
                          ? ''
                          : _currentDistrict,
                      branchController.text,
                      _currentType == 'Select workplace' ? '' : _currentType,
                    );
                  },
                  child: Text('Register'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  final ButtonStyle registerPOSButton = ElevatedButton.styleFrom(
    onPrimary: Colors.white,
    primary: Colors.blue,
    // minimumSize: Size(50, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
    ),
  );

  TextFormField _textFormField(controller, labelString) {
    return TextFormField(
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: labelString,
      ),
      onSaved: (value) {
        controller.text = value!;
      },
      controller: controller,
    );
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
                TextButton(
                  onPressed: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => TerminalInfo(thisUser.uid)));
                  },
                  child: Text('View'),
                ),
              ],
            ));
  }

  Widget _districtsDropDown(list) {
    return Row(children: [
      Text(
        'Select District',
        style: TextStyle(fontSize: 18.0),
      ),
      SizedBox(
        width: 30.0,
      ),
      DropdownButton<String>(
        disabledHint: Text(myUser.district),
        
        value: _currentDistrict,
        icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        style: const TextStyle(color: Colors.black),
        underline: Container(
          height: 2,
          color: Colors.blue,
        ),
        onChanged: (String? newValue) {
          setState(() {
            _currentDistrict = newValue!;
          });
        },
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    ]);
  }

  Widget _userTypesDropDown() {
    return Row(children: [
      Text(
        'User Workplace',
        style: TextStyle(fontSize: 18.0),
      ),
      SizedBox(
        width: 30.0,
      ),
      DropdownButton<String>(
        value: _currentType,
        icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        style: const TextStyle(color: Colors.black),
        underline: Container(
          height: 2,
          color: Colors.blue,
        ),
        onChanged: (String? newValue) {
          setState(() {
            _currentType = newValue!;
          });
        },
        items: userTypes.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    ]);
  }

  _createUser(email, pwd, username, district, branch, userType) async {
    try {
      UserCredential userCredntl = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pwd);
      User? tempUser = userCredntl.user;

      await DatabaseService(tempUser!.uid).updateUser(
        username,
        district,
        branch,
        userType,
      );
      _showDialog(context, 'User Created Successfully!');
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => EditUSer()));
    } catch (e) {
      _showDialog(context, e.toString());
    }
  }
}
