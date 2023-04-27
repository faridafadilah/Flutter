import 'package:dio/dio.dart';
import 'package:myresto/core/config/endpoint.dart';
import 'package:myresto/core/models/history_mdl.dart';

class HistoryService {
  static Dio dio = new Dio();

  static Future<List<HistoryModel>> getAll(
      String id, int page, int limit) async {
    int idUser = int.tryParse(id);
    var response = await dio.get(
        Endpoint.history + "/all/${idUser}?page=${page}&&limit=${limit}",
        options: Options(headers: {"Accept": "application/json"}));
    var _history = <HistoryModel>[];
    response.data["data"]["content"].forEach((value) {
      _history.add(HistoryModel.fromJson(value));
    });
    return _history;
  }

  static Future<HistoryResponse> addHistory(
      HistoryRequest historyRequest) async {
    var response = await dio.post(Endpoint.history,
        data: FormData.fromMap(historyRequest.toMap()),
        options: Options(headers: {"Accept": "application/json"}));

    return HistoryResponse.fromJson(response.data);
  }

  static Future<bool> deleteHistory(String id) async {
    int idHis = int.tryParse(id);
    var response = await dio.delete(Endpoint.history + "/${idHis}",
        options: Options(headers: {"Accept": "application/json"}));

    return response.data;
  }

  static Future<HistoryModel> getById(String id) async {
    int idHis = int.tryParse(id);
    var response = await dio.get(Endpoint.history + "/${idHis}",
        options: Options(headers: {"Accept": "application/json"}));
    return HistoryModel.fromJson(response.data["data"]);
  }
}
