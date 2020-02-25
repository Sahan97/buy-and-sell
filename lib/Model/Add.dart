class Add {
  String vegiName;
  String location;
  String quantity;
  String price;
  String imageUrl;
  String id;
  String uid;
  String contactNumber;
  String contactPerson;

  Add(
      {this.contactNumber,
      this.location,
      this.price,
      this.uid,
      this.vegiName,
      this.contactPerson,
      this.id,
      this.imageUrl,
      this.quantity});

  factory Add.fromJson(Map<String, dynamic> json, String id) => Add(
        uid: json['uid'],
        contactNumber: json['contactNumber'],
        contactPerson: json['contactPerson'],
        id: id,
        imageUrl: json['imageUrl']!= null ? json['imageUrl'] : "",
        location: json['location'],
        price: json['price'],
        quantity: json['quantity'],
        vegiName: json['vegiName'],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "contactNumber": contactNumber,
        "contactPerson": contactPerson,
        "id": id,
        "imageUrl": imageUrl,
        "location": location,
        "price": price,
        "quantity": quantity,
        "vegiName": vegiName
      };
}
