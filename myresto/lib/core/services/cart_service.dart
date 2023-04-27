import 'package:dio/dio.dart';
import 'package:myresto/core/config/endpoint.dart';
import 'package:myresto/core/models/cart_mdl.dart';

class CartServices {
  static Dio dio = new Dio();

  //get all by userId
  static Future<List<CartModel>> getAll(String id) async {
    int idUser = int.tryParse(id);
    var response = await dio.get(Endpoint.baseCarts + "/${idUser}",
        options: Options(headers: {"Accept": "application/json"}));
    var _foodData = <CartModel>[];
    response.data["data"].forEach((value) {
      _foodData.add(CartModel.fromJson(value));
    });
    return _foodData;
  }

  static Future<CartResponse> createCart(CartRequest CartModel) async {
    var response = await dio.post(Endpoint.baseCarts,
        data: FormData.fromMap(CartModel.toMap()),
        options: Options(headers: {"Accept": "application/json"}));

    return CartResponse.fromJson(response.data);
  }

  static Future<CartResponse> updateCart(
      CartRequest CartModel, String id) async {
    var foodData = CartModel.toMap();
    foodData['_method'] = 'PUT';
    int idCart = int.tryParse(id);
    var response = await dio.post(Endpoint.baseCarts + "/${idCart}",
        data: FormData.fromMap(foodData),
        options: Options(headers: {"Accept": "application/json"}));

    return CartResponse.fromJson(response.data);
  }

  static Future<CartResponse> deleteCart(String id) async {
    int idCart = int.tryParse(id);
    var response = await dio.delete(Endpoint.baseCarts + "/${idCart}",
        options: Options(headers: {"Accept": "application/json"}));

    return CartResponse.fromJson(response.data);
  }
}
