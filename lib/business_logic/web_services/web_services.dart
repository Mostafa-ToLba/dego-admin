import 'package:dego_admin/business_logic/cache_helper/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'end_points.dart';

class CustomDio {
  Future<dynamic> request(String endPoint,
      {body,
      String serverPath = EndPoints.baseURL,
      Map<String, dynamic>? headers,
      Map<String, dynamic>? quesryParameters,
      String? type}) async {
    // String? token = CacheHelper.getData(key: PrefKeys.TOKEN) ?? "";
    Map<String, dynamic>? _basicheaders = {
      "Accept": "*/*",
      "Content-Type": "application/json",
      // 'authorization': 'Bearer $token',
    };
    print("token");
    // print(token);
    Response response;
    final Dio dio = Dio();

    //  to cancel handshaking
    // (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient client) {
    //   client.badCertificateCallback =
    //       (X509Certificate cert, String host, int port) => true;
    //   return client;
    // };

    final options = Options(
      headers: headers ?? _basicheaders,
      sendTimeout: const Duration(milliseconds: 30000),
      receiveTimeout: const Duration(milliseconds: 30000),
    );

    Logger().i('>> request $serverPath $endPoint $headers');

    try {
      switch (type) {
        //**************** GET Request ********************** */
        case RequestType.Get:
          {
            print('hello from get');
            response = quesryParameters == null
                ? await dio.get(
                    serverPath + endPoint,
                    options: options,
                  )
                : await dio.get(
                    serverPath + endPoint,
                    options: options,
                    queryParameters: quesryParameters,
                  );
          }
          break;
        //**************** Post Request ********************** */
        case RequestType.Post:
          {
            print('hello from post');
            print(serverPath + endPoint);
            response = await dio.post(
              "$serverPath$endPoint",
              data: body ?? {},
              options: options,
            );
          }
          break;
        //**************** Put Request ********************** */
        case RequestType.Put:
          {
            response = await dio.put(serverPath + endPoint,
                data: body ?? {}, options: options);
          }
          break;
        //**************** Delete Request ********************** */
        case RequestType.Delete:
          {
            response = await dio.delete(serverPath + endPoint,
                data: body ?? {}, options: options);
          }
          break;
        //**************** default is get Request ********************** */
        default:
          response = await dio.get(
            serverPath + endPoint.toString(),
          );
          break;
      }

      Logger().w(response.toString());
      print("status code for $endPoint   =========${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else if (response.statusCode == 401 ||
          response.statusCode == 403 ||
          response.requestOptions.data == "Unauthorized") {
        request(
          endPoint,
          body: body,
          headers: headers,
          serverPath: serverPath,
          type: type,
        );
      }
    } on DioException catch (e) {
      print('🌐🌐ERROR in http $type for $endPoint:🌐🌐\n' + e.toString());
      Logger().e(e.response?.data);
      Logger().e(e.message);
      Logger().wtf(e.message);
      if (e.message!.contains("SocketException")) {
        print('No Internet connection 😑');
        //* go to no page and continue call api again
        Keys.navigatorKey.currentState!
            .push(MaterialPageRoute(
                builder: (_) => const Center(child: Text("No internet"))))
            .then((value) {
          request(endPoint,
              body: body, headers: headers, serverPath: serverPath, type: type);
        });
        throw CustomDioException("No Internet connection !", 404);
        //* if token is invalid
      }  else {
        throw CustomDioException(
            e.response?.data ?? "Bad Network Or Server Not available now",
            e.response!.statusCode ?? 500);
      }
    }
  }

  void _throwIfNoSuccess(Response response) {
    if (response.statusCode == 401) {
      // go to login again
    }
    if (response.statusCode! > 300) {
      final errorMsg = response.data;
      throw CustomDioException(errorMsg, response.statusCode ?? 500);
    }
  }
}

class DioUploadFileModel {
  final String filePath;
  final String fileFiledName;

  const DioUploadFileModel(
      {required this.filePath, required this.fileFiledName});
}

class CustomDioException implements Exception {
  dynamic data;
  int code;

  CustomDioException(this.data, this.code);

  @override
  String toString() {
    return data.toString();
  }
}
