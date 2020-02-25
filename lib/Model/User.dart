class User {
    String firstName;
    String lastName;
    String tel;
    String userName;
    String password;
    String uid;

    User({
        this.firstName,
        this.lastName,
        this.tel,
        this.userName,
        this.password,
        this.uid
    });

    factory User.fromJson(Map<String, dynamic> json, String uid2) => User(
        firstName: json["firstName"],
        lastName: json["lastName"],
        tel: json["tel"],
        userName: json["userName"],
        password: json["password"],
        uid: uid2
    );

    Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "tel": tel,
        "userName": userName,
        "password": password,
        "uid":uid,
    };
}
