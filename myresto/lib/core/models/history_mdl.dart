class HistoryModel {
  String id;
  String foodId;
  String title;
  int price;
  String image;
  String userId;
  String tanggal;
  int count;
  int totalPrice;

  HistoryModel(
      {this.count,
      this.foodId,
      this.id,
      this.image,
      this.price,
      this.tanggal,
      this.title,
      this.totalPrice,
      this.userId});

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      title: json['title'],
      price: int.parse(json['price'].toString()),
      count: int.parse(json['count'].toString()),
      totalPrice: int.parse(json['totalPrice'].toString()),
      foodId: json['foodId'].toString(),
      id: json['id'].toString(),
      image: json['image'].toString(),
      tanggal: json['tanggal'].toString(),
      userId: json['userId'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['title'] = title;
    map['price'] = price;

    return map;
  }
}

class HistoryResponse {
  int status;
  String message;

  HistoryResponse({this.status, this.message});

  factory HistoryResponse.fromJson(Map<String, dynamic> json) {
    return HistoryResponse(
        status: int.parse(json['status'].toString()), message: json['message']);
  }
}

class HistoryRequest {
  final int foodId;
  final int userId;
  final int totalPrice;
  final int count;

  HistoryRequest({this.count, this.foodId, this.totalPrice, this.userId});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['userId'] = userId;
    map['foodId'] = foodId;
    map['totalPrice'] = totalPrice;
    map['count'] = count;

    return map;
  }
}
