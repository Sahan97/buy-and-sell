import 'package:buy_n_sell/Model/Add.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AddDetails extends StatelessWidget {
  final Add add;
  AddDetails({this.add});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
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
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: Text(
                    add.vegiName,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                detail(
                  desc: 'Quantity',
                  child: Container(
                    child: Text(
                      add.quantity + ' Kg',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
                detail(
                  desc: 'Price',
                  child: Container(
                    child: Text(
                      'Rs. ' + add.price,
                      style: TextStyle(color: Colors.green, fontSize: 25),
                    ),
                  ),
                ),
                detail(
                  desc: 'Location',
                  child: Container(
                    child: Text(
                      'At ' + add.location,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
                detail(
                  desc: 'Contact Person',
                  child: Container(
                    child: Text(
                      add.contactPerson,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
                detail(
                  desc: 'Contact Number',
                  child: Container(
                    child: GestureDetector(
                      onTap: () async {
                        print('object');
                        await launch("tel:" + add.contactNumber);
                      },
                      child: Text(
                        add.contactNumber,
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
                ),
                add.imageUrl.isNotEmpty
                    ? detail(
                        desc: 'Image',
                        needLeftMargin: false,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Image.network(add.imageUrl),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget detail({String desc, Widget child, bool needLeftMargin = true}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 2,
            color: Colors.white,
          ),
          Container(
            padding: EdgeInsets.only(left: 10, top: 5),
            child: Text(
              desc,
              style: TextStyle(color: Colors.white60),
            ),
          ),
          Container(
              margin: EdgeInsets.only(
                  bottom: 20, left: needLeftMargin ? 40 : 0, top: 10),
              child: child)
        ],
      ),
    );
  }
}
