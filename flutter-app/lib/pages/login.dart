import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              errorMessage != null
                  ? Card(
                      color: Colors.pink,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          errorMessage,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  : Container(),
              RaisedButton(
                child: Text("Login"),
                onPressed: () async {
                  try {
                    setState(() {
                      errorMessage = null;
                    });
                    var credential = EmailAuthProvider.getCredential(
                      email: "potato@tomato.com",
                      password: "123456789",
                    );
                    await _auth.signInWithCredential(credential);
                    Navigator.of(context).pop();
                  } catch (ex) {
                    setState(() {
                      errorMessage = ex.message;
                    });
                  }
                },
              ),
              RaisedButton(
                child: Text('Sign in'),
                onPressed: () async {
                  try {
                    setState(() {
                      errorMessage = null;
                    });
                    await _auth.createUserWithEmailAndPassword(
                      email: "potato@tomato.com",
                      password: "123456789",
                    );
                  } catch (ex) {
                    setState(() {
                      errorMessage = ex.message;
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
