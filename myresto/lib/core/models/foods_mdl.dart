import 'package:dio/dio.dart';

class FoodModel {
  String id;
  String title;
  String description;
  int price;
  String image;
  String fullDescription;
  MultipartFile imageFile;

  //constructor
  FoodModel(
      {this.id,
      this.title,
      this.description,
      this.image,
      this.price,
      this.fullDescription,
      this.imageFile});

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'].toString(),
      title: json['title'],
      description: json['description'],
      image: json['image'],
      price: int.parse(json['price'].toString()),
      fullDescription: json['fullDescription'],
    );
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['description'] = description;
    map['fullDescription'] = fullDescription;
    map['price'] = price;
    map['image_file'] = imageFile;

    return map;
  }
}

class FoodResponse {
  int status;
  String message;

  FoodResponse({this.status, this.message});

  factory FoodResponse.fromJson(Map<String, dynamic> json) {
    return FoodResponse(
        status: int.parse(json['status'].toString()), message: json['message']);
  }
}
