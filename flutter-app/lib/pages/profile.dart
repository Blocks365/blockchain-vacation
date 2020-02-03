import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String errorMessage;
  String userId;

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null || userId == '') {
      return Scaffold(body: Center(child: Text("loading")));
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: StreamBuilder<DocumentSnapshot>(
              stream: Firestore.instance
                  .collection('users')
                  .document(userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text('Loading data');
                }

                return buildContent(User.fromSnapshot(snapshot.data));
              }),
        ),
      ),
    );
  }

  Column buildContent(User user) {
    return Column(
      children: <Widget>[
        TextFormField(
            initialValue: this.userId,
            enabled: false,
            decoration: InputDecoration(labelText: 'UserID')),
        TextFormField(decoration: InputDecoration(labelText: 'Private key'))
      ],
    );
  }

  void getUserId() async {
    var user = await _auth.currentUser();
    setState(() {
      this.userId = user.uid;
    });
  }
}

class User {
  final String privateKey;
  final String name;
  final DocumentReference reference;

  User.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map['name'],
        privateKey = map['privateKey'];

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data ?? Map.identity(),
            reference: snapshot.reference);
}
