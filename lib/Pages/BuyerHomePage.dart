import 'package:buy_n_sell/Components/AddItem.dart';
import 'package:buy_n_sell/Model/Add.dart';
import 'package:buy_n_sell/Pages/FirstPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BuyerHome extends StatefulWidget {
  @override
  _BuyerHomeState createState() => _BuyerHomeState();
}

class _BuyerHomeState extends State<BuyerHome> {
  bool dataLoading = false;
  List<Add> createdAdds = [];
  List<Add> filteredAdds = [];
  @override
  void initState() {
    getCreatedAdds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello to Buy and Sell'),
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
              : Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10,right: 10,top: 5),
                      padding: EdgeInsets.only(left: 10,right: 10),
                      decoration: BoxDecoration(
                        color: Colors.white54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.search, color: Colors.black,),
                          hintText: 'Search Here'
                        ),
                        onChanged: (value){
                          filter(value);
                        },
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: listView(),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  filter(String searchText){
    List<Add> temp = [];
    createdAdds.forEach((add){
      String name = add.vegiName.toLowerCase()+'';
      if(name.contains(searchText.toLowerCase())){
        temp.add(add);
      }
    });
    setState(() {
      filteredAdds = temp;
    });
  }

  Widget listView() {
    return Container(
      child: ListView.builder(
        itemCount: filteredAdds.length,
        itemBuilder: (BuildContext context, int index) =>
            AddItem(add: filteredAdds[index], accessToDelete: false),
      ),
    );
  }

  getCreatedAdds() {
    setState(() {
      dataLoading = true;
      print('loading data');
    });
    Firestore.instance.collection('Add').getDocuments().then((data) {
      createdAdds.clear();
      data.documents.forEach((add) {
        createdAdds.add(Add.fromJson(add.data, add.documentID));
      });
      filteredAdds = createdAdds;
      setState(() {
        dataLoading = false;
        print('data loaded');
      });
    });
  }
}
