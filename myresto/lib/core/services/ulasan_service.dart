import 'package:dio/dio.dart';
import 'package:myresto/core/config/endpoint.dart';
import 'package:myresto/core/models/ulasan_mdl.dart';

class UlasanService {
  static Dio dio = new Dio();

  static Future<List<UlasanModel>> getAll(String id) async {
    int idUser = int.tryParse(id);
    var response = await dio.get(Endpoint.ulasan + "/all/${idUser}",
        options: Options(headers: {"Accept": "application/json"}));
    var _ulasan = <UlasanModel>[];
    response.data["data"].forEach((value) {
      _ulasan.add(UlasanModel.fromJson(value));
    });
    return _ulasan;
  }

  static Future<UlasanResponse> addUlasan(UlasanRequest ulasanRequest) async {
    var response = await dio.post(Endpoint.ulasan,
        data: FormData.fromMap(ulasanRequest.toMap()),
        options: Options(headers: {"Accept": "application/json"}));

    return UlasanResponse.fromJson(response.data);
  }

  static Future<UlasanResponse> deleteUlasan(String id) async {
    int idUlas = int.tryParse(id);
    var response = await dio.delete(Endpoint.ulasan + "/${idUlas}",
        options: Options(headers: {"Accept": "application/json"}));

    return UlasanResponse.fromJson(response.data);
  }

  static Future<UlasanModel> getById(String id) async {
    int idHis = int.tryParse(id);
    var response = await dio.get(Endpoint.ulasan + "/${idHis}",
        options: Options(headers: {"Accept": "application/json"}));
    return UlasanModel.fromJson(response.data["data"]);
  }
}
