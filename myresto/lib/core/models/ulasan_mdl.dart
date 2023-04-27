class UlasanModel {
  String id;
  String username;
  double rating;
  String comment;
  String foodId;
  String userId;
  String tanggal;

  UlasanModel(
      {this.id,
      this.comment,
      this.foodId,
      this.rating,
      this.tanggal,
      this.userId,
      this.username});

  factory UlasanModel.fromJson(Map<String, dynamic> json) {
    return UlasanModel(
        id: json['id'].toString(),
        comment: json['comment'],
        foodId: json['foodId'].toString(),
        rating: json['rating'],
        tanggal: json['tanggal'].toString(),
        userId: json['userId'].toString(),
        username: json['username']);
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['comment'] = comment;
    map['foodId'] = foodId;
    map['rating'] = rating;
    map['tanggal'] = tanggal;
    map['userId'] = userId;
    map['username'] = username;
    return map;
  }
}

class UlasanResponse {
  int status;
  String message;

  UlasanResponse({this.status, this.message});

  factory UlasanResponse.fromJson(Map<String, dynamic> json) {
    return UlasanResponse(
        status: int.parse(json['status'].toString()), message: json['message']);
  }
}

class UlasanRequest {
  final int userId;
  final int foodId;
  final String comment;
  final double rating;

  final int historyId;

  UlasanRequest(
      {this.comment, this.foodId, this.rating, this.userId, this.historyId});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['userId'] = userId;
    map['foodId'] = foodId;
    map['comment'] = comment;
    map['rating'] = rating;
    map['historyId'] = historyId;

    return map;
  }
}
