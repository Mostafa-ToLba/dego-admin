import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class RemoteDataSource {
  final Dio dioRequest;

  RemoteDataSource({required this.dioRequest});

  Future<Either<ServerError, Object>> getData({
    required String url,
    required Map<String, dynamic>? query,
    required String? token,
    data,
  }) async {
    try {
      final response = await dioRequest.get(
        url + token!,
        queryParameters: query,
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        return Right(json.decode(response.data));
      } else {
        return Left(ServerError());
      }
    } on DioException catch (_) {
      return Left(ServerError());
    }
  }

  Future<Either<ServerError, Object>> putData({
    required String url,
    required Map<String, dynamic> data,
    required String? token,
  }) async {
    try {
      Response response = await dioRequest.patch(
        url,
        data: data,
        options: Options(
          headers: {
            'Cookie':
                'OpenIdConnect.nonce.S88qwWwOQp%2F3TqKJ0Nepxv5bu7H7Z440Zlf6jGWl4xA%3D=QVFBQUFOQ01uZDhCRmRFUmpIb0F3RV9DbC1zQkFBQUF2X05OTDdlbElVT21fbEpEWVdfR2hBQUFBQUFDQUFBQUFBQVFaZ0FBQUFFQUFDQUFBQUNqQTNCcnVPSGI2akc5cmtTeUd2VHJBMVFqdUlzNVRYQ1VJLURvSi03MEt3QUFBQUFPZ0FBQUFBSUFBQ0FBQUFBUGxqaWxxb1dSQlhJLWN4eWxpZTdFSHl2ZThTZGYyM1h6b1JmcXljMW5ZSUFBQUFEREtDdFhRcGIzdm9NdmlKT2VSMG1kSXg0T282dlJMSThjZ2ZCZzFhNTh0T19oRTU1STV5M00yaFdjcjFHaVRGVEplTVp5X1FuU3lTSWF0eTJncXh5ZUdac2czQ2YxNVh2bzRORTRXMWVOWHlycU1OOVktcDJjSTh3c0YyNEc4bTN6Tmc1eGg5Vi00RTNGdnpIb0FZbFVjM3lkRmo2MWREajlMcU1QQmw4b3MwQUFBQUJMQk82NVMtQzBEdGJ0NjA1ME4zTGNZS2RoTTlUdUdwSUpEcVBwRWkwVmliMHpnMG9DcXc2bUp3bGZoYjdOb2VHVW9TT0c4NDRkMUNtUXFpY2ptMHR2; OpenIdConnect.nonce.TNmcQjU6a8IK156dgG3SdSV%2Fzg7P7oK3MseSgclbaYw%3D=QVFBQUFOQ01uZDhCRmRFUmpIb0F3RV9DbC1zQkFBQUF2X05OTDdlbElVT21fbEpEWVdfR2hBQUFBQUFDQUFBQUFBQVFaZ0FBQUFFQUFDQUFBQUQ1ak9hWWN4Skd3d1hqZFA1YzZGSHRkX05nYTNmQ29mZUQ5ZF9TZWU4eEN3QUFBQUFPZ0FBQUFBSUFBQ0FBQUFBWm10OW5EdWd1UGkxc0pjNlVtZFZ5djZNel9sTy1rMlRuYzF3UTJqMlJINEFBQUFEeXV0MDk5OGc5RWdLMnJ0dlBSMENESEF5YnBVb09hcFpMZmxfelRCSEloSXNxY2tGakQ5OXFLbzVuTXRLbjM2Z3VEcnFXbnJiZ0pPZy1nVVdJeDVfbm5aWXJtcEhGb2Q5ZndXbTU1UnNpY2NFVDFzV0ZVRFlrWlUxVllIV3ZsR25HVGdSOFFHQUFmOWVJeFNrUS1zczNUZ2Q3c2xtUFBWamozNnpFdHhvVWEwQUFBQUJPdjAtTnR5WEZBTTZsQTlJVHQxbGk4bGU2cnp5MVB2cUdZUVUzbjV4QTdZMldXSnNpWjQ3Um5HT0pUMG02VUgwc2FCeHZmYTY5ZDBmLUVTOGpqeE1k',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          followRedirects: true,
          validateStatus: (status) => true,
        ),
      );
      if (response.statusCode == 200) {
        return Right(json.decode(response.data));
      } else {
        return Left(ServerError());
      }
    } on DioException catch (_) {
      return Left(ServerError());
    }
  }

  Future<Either<ServerError, Object>> postData({
    required String url,
    required Map<String, dynamic> data,
    required String token,
  }) async {
    try {
      final response = await dioRequest.post(
        url + token,
        data: data,
        options: Options(
          headers: {
            // 'Content-Type': 'application/x-www-form-urlencoded',
            'Cookie':
                'OpenIdConnect.nonce.S88qwWwOQp%2F3TqKJ0Nepxv5bu7H7Z440Zlf6jGWl4xA%3D=QVFBQUFOQ01uZDhCRmRFUmpIb0F3RV9DbC1zQkFBQUF2X05OTDdlbElVT21fbEpEWVdfR2hBQUFBQUFDQUFBQUFBQVFaZ0FBQUFFQUFDQUFBQUNqQTNCcnVPSGI2akc5cmtTeUd2VHJBMVFqdUlzNVRYQ1VJLURvSi03MEt3QUFBQUFPZ0FBQUFBSUFBQ0FBQUFBUGxqaWxxb1dSQlhJLWN4eWxpZTdFSHl2ZThTZGYyM1h6b1JmcXljMW5ZSUFBQUFEREtDdFhRcGIzdm9NdmlKT2VSMG1kSXg0T282dlJMSThjZ2ZCZzFhNTh0T19oRTU1STV5M00yaFdjcjFHaVRGVEplTVp5X1FuU3lTSWF0eTJncXh5ZUdac2czQ2YxNVh2bzRORTRXMWVOWHlycU1OOVktcDJjSTh3c0YyNEc4bTN6Tmc1eGg5Vi00RTNGdnpIb0FZbFVjM3lkRmo2MWREajlMcU1QQmw4b3MwQUFBQUJMQk82NVMtQzBEdGJ0NjA1ME4zTGNZS2RoTTlUdUdwSUpEcVBwRWkwVmliMHpnMG9DcXc2bUp3bGZoYjdOb2VHVW9TT0c4NDRkMUNtUXFpY2ptMHR2; OpenIdConnect.nonce.TNmcQjU6a8IK156dgG3SdSV%2Fzg7P7oK3MseSgclbaYw%3D=QVFBQUFOQ01uZDhCRmRFUmpIb0F3RV9DbC1zQkFBQUF2X05OTDdlbElVT21fbEpEWVdfR2hBQUFBQUFDQUFBQUFBQVFaZ0FBQUFFQUFDQUFBQUQ1ak9hWWN4Skd3d1hqZFA1YzZGSHRkX05nYTNmQ29mZUQ5ZF9TZWU4eEN3QUFBQUFPZ0FBQUFBSUFBQ0FBQUFBWm10OW5EdWd1UGkxc0pjNlVtZFZ5djZNel9sTy1rMlRuYzF3UTJqMlJINEFBQUFEeXV0MDk5OGc5RWdLMnJ0dlBSMENESEF5YnBVb09hcFpMZmxfelRCSEloSXNxY2tGakQ5OXFLbzVuTXRLbjM2Z3VEcnFXbnJiZ0pPZy1nVVdJeDVfbm5aWXJtcEhGb2Q5ZndXbTU1UnNpY2NFVDFzV0ZVRFlrWlUxVllIV3ZsR25HVGdSOFFHQUFmOWVJeFNrUS1zczNUZ2Q3c2xtUFBWamozNnpFdHhvVWEwQUFBQUJPdjAtTnR5WEZBTTZsQTlJVHQxbGk4bGU2cnp5MVB2cUdZUVUzbjV4QTdZMldXSnNpWjQ3Um5HT0pUMG02VUgwc2FCeHZmYTY5ZDBmLUVTOGpqeE1k',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          },
          followRedirects: true,
          validateStatus: (status) => true,
        ),
      );
      if (response.statusCode == 200) {
        return Right(response.data);
      } else {
        return Left(ServerError());
      }
    } on DioException catch (_) {
      return Left(ServerError());
    }
  }
}

class ServerError extends Error {}
