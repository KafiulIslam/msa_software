import 'package:dio/dio.dart';
import 'dio.dart';

Future<Map<String, dynamic>> getUserInfo() async {
  try {
    var response = await dio.get('users');
    return {'status': 'success', 'data': response.data};
  } on DioError catch (e) {
    return getErrorResponse(e);
  }
}

Future<Map<String, dynamic>> getUserDetails(int id) async {
  try {
    var response = await dio.get('users/$id');
    return {'status': 'success', 'data': response.data};
  } on DioError catch (e) {
    return getErrorResponse(e);
  }
}