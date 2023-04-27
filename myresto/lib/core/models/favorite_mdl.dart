class FavoriteModel {
  String foodId;
  String idFavorite;
  String title;
  int price;
  String photoFood;
  String description;
  bool favorite;

  //constructor
  FavoriteModel(
      {this.foodId,
      this.title,
      this.idFavorite,
      this.price,
      this.photoFood,
      this.description,
      this.favorite});

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
        foodId: json['foodId'].toString(),
        idFavorite: json['idFavorite'].toString(),
        title: json['title'],
        price: int.parse(json['price'].toString()),
        photoFood: json['photoFood'],
        description: json['description'],
        favorite: json['favorite']);
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['foodId'] = foodId;
    map['idFavorite'] = idFavorite;
    map['title'] = title;
    map['price'] = price;
    map['photoFood'] = photoFood;
    map['description'] = description;
    map['favorite'] = favorite;

    return map;
  }
}

class FavResponse {
  int status;
  String message;

  FavResponse({this.status, this.message});

  factory FavResponse.fromJson(Map<String, dynamic> json) {
    return FavResponse(
        status: int.parse(json['status'].toString()), message: json['message']);
  }
}

class FavRequest {
  final bool favorite;
  final int userId;
  final int foodId;

  FavRequest({this.favorite, this.userId, this.foodId});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['favorite'] = favorite;
    map['userId'] = userId;
    map['foodId'] = foodId;

    return map;
  }
}
