import 'package:buy_n_sell/Components/AddItem.dart';
import 'package:buy_n_sell/Model/Add.dart';
import 'package:buy_n_sell/Model/SavedData.dart';
import 'package:buy_n_sell/Pages/AddCreate.dart';
import 'package:buy_n_sell/Pages/FirstPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SellerHome extends StatefulWidget {
  @override
  _SellerHomeState createState() => _SellerHomeState();
}

class _SellerHomeState extends State<SellerHome> {
  bool dataLoading = false;
  List<Add> createdAdds = [];
  @override
  void initState() {
    getCreatedAdds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello, ' + SavedData.currentUser.firstName),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => FirstPage(),
                ),
              );
            },
            icon: Icon(Icons.exit_to_app),
          )
        ],
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
            child: dataLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : listView()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => AddCreate(),
            ),
          ).then((onValue){
            getCreatedAdds();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget listView() {
    return Container(
      child: ListView.builder(
        itemCount: createdAdds.length,
        itemBuilder: (BuildContext context, int index) =>
            AddItem(add: createdAdds[index], accessToDelete: true),
      ),
    );
  }

  getCreatedAdds() {
    setState(() {
      dataLoading = true;
      print('loading data');
    });
    Firestore.instance
        .collection('Add')
        .where('uid', isEqualTo: SavedData.currentUser.uid)
        .getDocuments()
        .then((data) {
      createdAdds.clear();
      data.documents.forEach((add) {
        createdAdds.add(Add.fromJson(add.data, add.documentID));
      });

      setState(() {
        dataLoading = false;
        print('data loaded');
      });
    });
  }
}
