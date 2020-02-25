import 'package:buy_n_sell/Components/ButtonWithLoading.dart';
import 'package:buy_n_sell/Messages/Messages.dart';
import 'package:buy_n_sell/Model/SavedData.dart';
import 'package:buy_n_sell/Model/User.dart';
import 'package:buy_n_sell/Pages/SellerHome.dart';
import 'package:buy_n_sell/Pages/SignUpPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  String userName, password;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.grey,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/vegi2.jpg'), fit: BoxFit.cover),
        ),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black.withOpacity(0.8),
          child: Column(
            children: <Widget>[
              Expanded(
                child: SizedBox(),
              ),
              Container(
                height: 270,
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10)),
                child: SingleChildScrollView(
                  child: form(),
                ),
              ),
              Expanded(
                child: SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget form() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          textFieldDeco(
            child: TextFormField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(hintText: "User Name"),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              validator: (value) {
                if (value.isEmpty) {
                  return "User Name is required!";
                }
                return null;
              },
              onSaved: (value) {
                userName = value;
              },
            ),
          ),
          textFieldDeco(
            child: TextFormField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(hintText: "Password"),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              validator: (value) {
                if (value.isEmpty) {
                  return "Password is required!";
                } else if (value.length < 8) {
                  return "Password should have at least 8 characters!";
                }
                return null;
              },
              obscureText: true,
              onSaved: (value) {
                password = value;
              },
            ),
          ),
          ButtonWithLoading(
              'Login', Colors.green, loginBtnAction, isLoading, 200),
          ButtonWithLoading('Signup', Colors.blue, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => SignUp(),
              ),
            );
          }, false, 200),
        ],
      ),
    );
  }

  Widget textFieldDeco({Widget child}) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }

  loginBtnAction() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    _formKey.currentState.save();
    Firestore.instance
        .collection('User')
        .where('userName', isEqualTo: userName)
        .where('password', isEqualTo: password)
        .getDocuments()
        .then((user) {
      setState(() {
        isLoading = false;
      });
      if (user.documents.length == 1) {
        SavedData.currentUser =
            User.fromJson(user.documents[0].data, user.documents[0].documentID);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => SellerHome(),
          ),
        );
      } else {
        Messages.simpeMessage(
            context: context,
            title: 'Login Failed!',
            content: 'Please check your username, password and try again!');
      }
    });
  }
}
