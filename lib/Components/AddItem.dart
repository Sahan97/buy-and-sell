import 'package:buy_n_sell/Model/Add.dart';
import 'package:buy_n_sell/Pages/AddDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddItem extends StatefulWidget {
  final Add add;
  final bool accessToDelete;
  AddItem({this.add, this.accessToDelete});
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  bool isDeleted = false;
  @override
  Widget build(BuildContext context) {
    return isDeleted ? Container() : Container(
            margin: EdgeInsets.all(5),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => AddDetails(add:widget.add),
                  ),
                );
              },
              child: Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: widget.add.imageUrl.isNotEmpty
                        ? NetworkImage(widget.add.imageUrl)
                        : AssetImage('assets/vegi3.jpg'),
                  ),
                  title: Text(
                    widget.add.vegiName + ' (' + widget.add.quantity + ' Kg)',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Rs.' + widget.add.price),
                  trailing: widget.accessToDelete
                      ? IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              isDeleted = true;
                              Firestore.instance
                                  .collection('Add')
                                  .document(widget.add.id)
                                  .delete();
                            });
                          },
                        )
                      : Container(width: 1,height: 1,),
                ),
              ),
            ),
          );
  }
}
