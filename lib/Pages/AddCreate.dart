import 'dart:io';
import 'package:buy_n_sell/Components/ButtonWithLoading.dart';
import 'package:buy_n_sell/Messages/Messages.dart';
import 'package:buy_n_sell/Model/SavedData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddCreate extends StatefulWidget {
  @override
  _AddCreateState createState() => _AddCreateState();
}

class _AddCreateState extends State<AddCreate> {
  final _formKey = GlobalKey<FormState>();
  String vegiName, location, contactPerson, contactNumber;
  int qty;
  double price;
  File selectedImage;
  bool uploadingPhoto = false, isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create an Advertisement'),
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
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            color: Colors.white.withOpacity(0.3),
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
              decoration: InputDecoration(hintText: "Vegitable Name"),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              validator: (value) {
                if (value.isEmpty) {
                  return "Vegitable Name is required!";
                }
                return null;
              },
              onSaved: (value) {
                vegiName = value;
              },
            ),
          ),
          textFieldDeco(
            child: TextFormField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(hintText: "Location"),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              validator: (value) {
                if (value.isEmpty) {
                  return "Location is required!";
                }
                return null;
              },
              onSaved: (value) {
                location = value;
              },
            ),
          ),
          textFieldDeco(
            child: TextFormField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(hintText: "Quantity (Kg)"),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return "Quantity is required!";
                }
                return null;
              },
              onSaved: (value) {
                qty = int.parse(value);
              },
            ),
          ),
          textFieldDeco(
            child: TextFormField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(hintText: "Price (Rs)"),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return "Price is required!";
                }
                return null;
              },
              onSaved: (value) {
                price = double.parse(value);
              },
            ),
          ),
          selectedImage == null
              ? RaisedButton(
                  onPressed: addPhotosHandler,
                  child: Text('add a photo'),
                )
              : Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Stack(
                    children: <Widget>[
                      Image.file(selectedImage),
                      Positioned(
                        right: 5,
                        top: 5,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              selectedImage = null;
                            });
                          },
                          icon: Icon(Icons.close),
                        ),
                      ),
                      uploadingPhoto
                          ? Positioned.fill(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
          textFieldDeco(
            child: TextFormField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(hintText: "Contact Person"),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              initialValue: SavedData.currentUser.firstName +
                  ' ' +
                  SavedData.currentUser.lastName,
              validator: (value) {
                if (value.isEmpty) {
                  return "Contact person is required!";
                }
                return null;
              },
              onSaved: (value) {
                contactPerson = value;
              },
            ),
          ),
          textFieldDeco(
            child: TextFormField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(hintText: "Contact number"),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              initialValue: SavedData.currentUser.tel,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value.isEmpty) {
                  return "Contact number is required!";
                }
                return null;
              },
              onSaved: (value) {
                contactNumber = value;
              },
            ),
          ),
          ButtonWithLoading(
              'Submit', Colors.green, submitBtnAction, isLoading, 200)
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

  addPhotosHandler() {
    ImagePicker.pickImage(source: ImageSource.gallery).then((File image) {
      if (image != null) {
        setState(() {
          selectedImage = image;
        });
      }
    });
  }

  submitBtnAction() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      isLoading = true;
    });
    if (selectedImage != null) {
      setState(() {
        uploadingPhoto = true;
      });
      StorageUploadTask uploadTask = FirebaseStorage()
          .ref()
          .child('images/' +
              SavedData.currentUser.uid +
              DateTime.now().microsecondsSinceEpoch.toString())
          .putFile(selectedImage);
      String dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
      setState(() {
        uploadingPhoto = false;
      });
      sendData(dowurl);
    } else {
      sendData('');
    }
  }

  sendData(String url) {
    Firestore.instance.collection('Add').document().setData({
      'vegiName': vegiName,
      'location': location,
      'quantity': qty.toString(),
      'price': price.toStringAsFixed(2),
      'imageUrl': url,
      'contactPerson': contactPerson,
      'contactNumber': contactNumber,
      'uid': SavedData.currentUser.uid
    }).then((onValue) {
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
      Messages.simpeMessage(
          context: context,
          title: 'Successfull!',
          content: 'Your advertisement is now alive!');
    });
  }
}
