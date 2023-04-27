import 'package:dio/dio.dart';
import 'package:myresto/core/config/endpoint.dart';
import 'package:myresto/core/models/action_mdl.dart';

class AuthService {
  static Dio dio = new Dio();
  //register
  static Future<ActionModel> register(Map registerData) async {
    var response = await dio.post(Endpoint.register,
        data: FormData.fromMap(registerData),
        options: Options(headers: {
          "Accept": "application/json",
        }));
    return ActionModel.fromJson(response.data);
  }

  //login
  static Future<ActionModel> login2(Map loginData) async {
    var response = await dio.post(Endpoint.login,
        data: FormData.fromMap(loginData),
        options: Options(headers: {"Accept": "application/json"}));

    return ActionModel.fromJson(response.data);
  }

  static Future<ActionModel> getByUser(String id) async {
    int idUser = int.tryParse(id);
    var response = await dio.get(Endpoint.profile + "/${idUser}",
        options: Options(headers: {"Accept": "application/json"}));
    return ActionModel.fromJson(response.data);
  }

  static Future<ActionModel> updateProfile(Map registerData, String id) async {
    int idUser = int.tryParse(id);
    var response = await dio.post(Endpoint.profile + "/${idUser}",
        data: FormData.fromMap(registerData),
        options: Options(headers: {
          "Accept": "application/json",
        }));
    return ActionModel.fromJson(response.data);
  }
}
