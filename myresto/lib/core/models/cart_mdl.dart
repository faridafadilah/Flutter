class CartModel {
  String idFood;
  String id;
  String title;
  int price;
  int quantity;
  String photoFood;
  bool isChecked;

  //constructor
  CartModel(
      {this.idFood,
      this.id,
      this.title,
      this.quantity,
      this.price,
      this.photoFood,
      this.isChecked = false});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
        title: json['title'],
        price: int.parse(json['price'].toString()),
        quantity: int.parse(json['quantity'].toString()),
        photoFood: json['photoFood'],
        idFood: json['foodId'].toString(),
        id: json['id'].toString());
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['title'] = title;
    map['quantity'] = quantity;
    map['price'] = price;
    map['photoFood'] = photoFood;

    return map;
  }
}

class CartResponse {
  int status;
  String message;

  CartResponse({this.status, this.message});

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
        status: int.parse(json['status'].toString()), message: json['message']);
  }
}

class CartRequest {
  final int quantity;
  final int userId;
  final int foodId;

  CartRequest({this.quantity, this.userId, this.foodId});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['quantity'] = quantity;
    map['userId'] = userId;
    map['foodId'] = foodId;

    return map;
  }
}
