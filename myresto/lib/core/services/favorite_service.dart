import 'package:dio/dio.dart';
import 'package:myresto/core/config/endpoint.dart';
import 'package:myresto/core/models/favorite_mdl.dart';

class FavoriteService {
  static Dio dio = new Dio();

  //get all by userId
  static Future<List<FavoriteModel>> getAll(String id) async {
    int idUser = int.tryParse(id);
    var response = await dio.get(Endpoint.favorite + "/${idUser}",
        options: Options(headers: {"Accept": "application/json"}));
    var _favData = <FavoriteModel>[];
    response.data["data"].forEach((value) {
      _favData.add(FavoriteModel.fromJson(value));
    });
    return _favData;
  }

  static Future<List<FavoriteModel>> getAllFav(String id) async {
    int idUser = int.tryParse(id);
    var response = await dio.get(Endpoint.favorite + "/all/${idUser}",
        options: Options(headers: {"Accept": "application/json"}));
    var _favData = <FavoriteModel>[];
    response.data["data"].forEach((value) {
      _favData.add(FavoriteModel.fromJson(value));
    });
    return _favData;
  }

  static Future<FavResponse> addFav(FavRequest FavoriteModel) async {
    var response = await dio.post(Endpoint.favorite,
        data: FormData.fromMap(FavoriteModel.toMap()),
        options: Options(headers: {"Accept": "application/json"}));

    return FavResponse.fromJson(response.data);
  }

  static Future<FavResponse> updateCart(
      FavRequest FavoriteModel, String id) async {
    var foodData = FavoriteModel.toMap();
    foodData['_method'] = 'PUT';
    int idFav = int.tryParse(id);
    var response = await dio.post(Endpoint.favorite + "/${idFav}",
        data: FormData.fromMap(foodData),
        options: Options(headers: {"Accept": "application/json"}));

    return FavResponse.fromJson(response.data);
  }
}
