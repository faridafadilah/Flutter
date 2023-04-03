import 'package:dio/dio.dart';
import 'package:myresto/core/config/endpoint.dart';
import 'package:myresto/core/models/foods_mdl.dart';

class FoodsServices {
  static Dio dio = new Dio();

  static Future<List<FoodModel>> getAll() async {
    var response = await dio.get(Endpoint.baseFoods,
        options: Options(headers: {"Accept": "application/json"}));
    var _foodData = <FoodModel>[];
    response.data["data"].forEach((value) {
      _foodData.add(FoodModel.fromJson(value));
    });
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
}
