import 'package:dio/dio.dart';

Future<Response> api(String url) async {
  final dio = Dio();
  try {
    final response = await dio.get(url);
    return response;
  } on DioError catch (e) {
    return e.response!;
  }
}
