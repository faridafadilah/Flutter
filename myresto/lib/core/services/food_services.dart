import 'package:dio/dio.dart';
import 'package:myresto/core/config/endpoint.dart';
import 'package:myresto/core/models/foods_mdl.dart';

class FoodsServices {
  static Dio dio = new Dio();

  static Future<List<FoodModel>> getAllFoods() async {
    var response = await dio.get(Endpoint.baseFoods + "/all",
        options: Options(headers: {"Accept": "application/json"}));
    var _favData = <FoodModel>[];
    response.data["data"].forEach((value) {
      _favData.add(FoodModel.fromJson(value));
    });
    return _favData;
  }

  static Future<List<FoodModel>> getAll(
      int page,
      int limit,
      double minPrice,
      double maxPrice,
      bool isFavorite,
      double minRating,
      double maxRating,
      String title) async {
    int minPrices = minPrice.toInt();
    int maxPrices = maxPrice.toInt();
    var response = await dio.get(
        Endpoint.baseFoods +
            "?${title != null ? "search=$title" : ""}&&page=${page}&&limit=${limit}&&isFavorite=${isFavorite}",
        options: Options(headers: {"Accept": "application/json"}));
    var _foodData = <FoodModel>[];
    response.data["data"]["content"].forEach((value) {
      _foodData.add(FoodModel.fromJson(value));
    });
    return _foodData; // tambahkan baris ini untuk mengembalikan data
  }

  static Future<FoodResponse> createFood(FoodModel foodModel) async {
    var response = await dio.post(Endpoint.baseFoods,
        data: FormData.fromMap(foodModel.toMap()),
        options: Options(headers: {"Accept": "application/json"}));

    return FoodResponse.fromJson(response.data);
  }

  static Future<FoodResponse> updateFood(FoodModel foodModel, String id) async {
    var foodData = foodModel.toMap();
    foodData['_method'] = 'PUT';

    var response = await dio.post(Endpoint.baseFoods + "/${id}",
        data: FormData.fromMap(foodData),
        options: Options(headers: {"Accept": "application/json"}));

    return FoodResponse.fromJson(response.data);
  }

  static Future<FoodResponse> deleteFood(String id) async {
    var response = await dio.delete(Endpoint.baseFoods + "/${id}",
        options: Options(headers: {"Accept": "application/json"}));

    return FoodResponse.fromJson(response.data);
  }

  static Future<FoodModel> getById(String id) async {
    int idFood = int.tryParse(id);
    var response = await dio.get(Endpoint.baseFoods + "/${idFood}",
        options: Options(headers: {"Accept": "application/json"}));
    return FoodModel.fromJson(response.data["data"]);
  }
}
