import 'package:buy_n_sell/Components/ButtonWithLoading.dart';
import 'package:buy_n_sell/Messages/Messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String firstName, lastName, tel, userName, password;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup'),
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
          child: Container(
            height: 270,
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(
              child: form(),
            ),
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
              decoration: InputDecoration(hintText: "First Name"),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              validator: (value) {
                if (value.isEmpty) {
                  return "First Name is required!";
                }
                return null;
              },
              onSaved: (value) {
                firstName = value;
              },
            ),
          ),
          textFieldDeco(
            child: TextFormField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(hintText: "Last Name"),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              validator: (value) {
                if (value.isEmpty) {
                  return "Last Name is required!";
                }
                return null;
              },
              onSaved: (value) {
                lastName = value;
              },
            ),
          ),
          textFieldDeco(
            child: TextFormField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(hintText: "Contact Number"),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              validator: (value) {
                if (value.isEmpty) {
                  return "Contact Number is required!";
                }
                return null;
              },
              onSaved: (value) {
                tel = value;
              },
            ),
          ),
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
              obscureText: true,
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
              onSaved: (value) {
                password = value;
              },
            ),
          ),
          ButtonWithLoading(
              'Signup', Colors.blue, signUpBtnAction, isLoading, 200)
        ],
      ),
    );
  }

  Widget textFieldDeco({Widget child}) {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }

  signUpBtnAction() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      isLoading = true;
    });
    Firestore.instance
        .collection('User')
        .where('userName', isEqualTo: userName)
        .getDocuments()
        .then((user) {
      if (user.documents.length > 0) {
        setState(() {
          isLoading = false;
        });
        Messages.simpeMessage(
            context: context,
            title: 'Signup Failed!',
            content:
                'Username is already exists. Please try with another Username!');
      } else {
        Firestore.instance.collection('User').document().setData({
          'firstName': firstName,
          'lastName': lastName,
          'tel': tel,
          'userName': userName,
          'password': password
        }).then((user) {
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context);
          Messages.simpeMessage(
              context: context,
              title: 'Successfully Signed in!',
              content:
                  'You are successfully signed in and you can login to system using provided Username and password!');
        });
      }
    });
  }
}
