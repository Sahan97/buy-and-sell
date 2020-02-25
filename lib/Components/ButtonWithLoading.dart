import 'package:flutter/material.dart';

class ButtonWithLoading extends StatelessWidget {
  ButtonWithLoading(
      this.text, this.backgroundColor, this.action, this.isLoading, this.width);
  final Function action;
  final String text;
  final Color backgroundColor;
  final bool isLoading;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 40,
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: RaisedButton(
        onPressed: isLoading ? null : action,
        child: isLoading
            ? Center(
                child: SizedBox(
                    height: 20, width: 20, child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),),
              )
            : Text(
                text,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
        color: backgroundColor,
      ),
    );
  }
}
