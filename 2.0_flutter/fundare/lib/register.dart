import 'dart:core';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterForm extends StatefulWidget {
  RegisterForm({Key key}) : super(key: key);
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController firstNameInputController;
  TextEditingController lastNameInputController;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;
  DateTime now = new DateTime.now();

  @override
  initState() {
    firstNameInputController = new TextEditingController();
    lastNameInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    confirmPwdInputController = new TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern = r'^[a-zA-Z0-9\._%+-]+@[A-Za-z0-9.-]+[\.A-Za-z]{2,3}$';
    RegExp email = new RegExp(pattern);
    if (!email.hasMatch(value)) {
      return 'Email must follow standard format:\n-username@domain.ext\n-e.g. fundareuser@gmail.com';
    } else {
      return null;
    }
  }

//T3stword!
  String pwdValidator(String value) {
    Pattern pattern = r'^((?=.*\d)(?=.*[A-Z])(?=.*\W).{8,})$';
    RegExp password = new RegExp(pattern);
    if (!password.hasMatch(value)) {
      return 'Invalid Password. Min 8 characters long\n-1 Uppercase letter\n-1 number\n-1 special character.';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Register'),
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
              key: _registerFormKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'First Name*', hintText: 'First Last'),
                    controller: firstNameInputController,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Last Name*', hintText: 'First Last'),
                    controller: lastNameInputController,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Email*',
                        hintText: 'emailaddress@domain.com'),
                    controller: emailInputController,
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidator,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Password*', hintText: '********'),
                    controller: pwdInputController,
                    obscureText: true,
                    validator: pwdValidator,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Confirm Password*', hintText: '********'),
                    controller: confirmPwdInputController,
                    obscureText: true,
                    validator: pwdValidator,
                  ),
                  RaisedButton(
                    child: Text('Register'),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      if (_registerFormKey.currentState.validate()) {
                        if (pwdInputController.text ==
                            confirmPwdInputController.text) {
                          FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: emailInputController.text,
                                  password: pwdInputController.text)
                              .then((currentUser) => Firestore.instance
                                  .collection('user_data')
                                  .document(currentUser.uid)
                                  .setData({
                                    "first": firstNameInputController.text,
                                    "last": lastNameInputController.text,
                                    "email": emailInputController.text,
                                    "password": pwdInputController.text,
                                    "locations": {},
                                  })
                                  .then((result) => {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                  'Thanks for registering!',
                                                ),
                                                content: Text(
                                                  'Click below to login!',
                                                ),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    child: Text('Login'),
                                                    onPressed: () {
                                                      Navigator
                                                          .pushReplacementNamed(
                                                              context,
                                                              '/login');
                                                    },
                                                  )
                                                ],
                                              );
                                            })
                                      })
                                  .catchError(
                                    (err) => showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              'Error',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red),
                                            ),
                                            content: Text(
                                              err,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red),
                                            ),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text('Login'),
                                                onPressed: () {
                                                  Navigator
                                                      .pushReplacementNamed(
                                                          context, "/login");
                                                },
                                              ),
                                            ],
                                          );
                                        }),
                                  ))
                              .catchError((err) => {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              'Error',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red),
                                            ),
                                            content: Text(
                                              'Email already exists. Please login.',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red),
                                            ),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text('Login'),
                                                onPressed: () {
                                                  Navigator
                                                      .pushReplacementNamed(
                                                          context, "/login");
                                                },
                                              ),
                                            ],
                                          );
                                        }),
                                    firstNameInputController.clear(),
                                    lastNameInputController.clear(),
                                    emailInputController.clear(),
                                    pwdInputController.clear(),
                                    confirmPwdInputController.clear(),
                                  });
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Error',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                  content: Text(
                                    'The passwords do not match.',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('Close'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              });
                        }
                      }
                    },
                  ),
                  Text('Already have an account?'),
                  FlatButton(
                    child: Text('Login here!'),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  )
                ],
              ),
            ))));
  }
}
