

import 'package:dego_admin/business_logic/web_services/end_points.dart';
import 'package:dego_admin/business_logic/web_services/web_services.dart';
import 'package:dio/dio.dart';

class HttpApi {
  CustomDio customDio = CustomDio();

//////////////////////////////////////////////////////////////////////////////////////////////////

//*******************  postVideoAndPic   *************************//

  Future<dynamic> postVideoAndPic({FormData? body}) async {
    final res = await customDio.request(
        EndPoints.baseURL+EndPoints.upload,
        type: RequestType.Post,
        body: body,
    );
    return res;
  }


}
