import 'package:buy_n_sell/Pages/BuyerHomePage.dart';
import 'package:buy_n_sell/Pages/LoginPage.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text('Welcome to Buy and Sell'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/vegi1.jpg'), fit: BoxFit.cover),
        ),
        child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black.withOpacity(0.8),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  middleButton(
                      color: Colors.green,
                      text: 'Seller',
                      action: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => LoginPage(),
                          ),
                        );
                      }),
                  middleButton(
                      color: Colors.blue,
                      text: 'Buyer',
                      action: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => BuyerHome(),
                          ),
                        );
                      })
                ],
              ),
            )),
      ),
    );
  }

  Widget middleButton({Color color, String text, Function action}) {
    return Container(
      height: 120,
      width: 120,
      margin: EdgeInsets.all(30),
      child: RaisedButton(
        onPressed: action,
        color: color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.white)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
