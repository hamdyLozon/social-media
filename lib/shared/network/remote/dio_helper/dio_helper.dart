import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioHelper{
  static late Dio dio;

  static init()
  {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://student.valuxapps.com/api/',
        receiveDataWhenStatusError:true,
      ),
    );
    dio.interceptors.add(PrettyDioLogger());
// customization
//     dio.interceptors.add(PrettyDioLogger(
//         requestHeader: true,
//         requestBody: true,
//         responseBody: true,
//         responseHeader: false,
//         error: true,
//         compact: true,
//         maxWidth: 90));
  }

  static Future<Response?> getData ({
    required String url,
    Map<String,dynamic>? query,
    String lang = 'en',
    String? token,
  })async
  {
    dio.options.headers={
      'Content-Type':'application/json',
      'lang':lang,
      'Authorization':token??'',
    };
    return await dio
        .get(url,queryParameters:query );
  }
  static Future<Response?> postData ({
    required String url,
    Map<String,dynamic>? query,
    required Map<String,dynamic> data,
    String lang = 'en',
    String? token,
  })async
  {
    // حجات متغيرة بتكون بال header في postman  بقدرش احطها فوق ف يحطها بفانكشن عشان اقدر اتعامل معها بمتغير
    dio.options.headers={
      // هاد ثابت بس معلش خليه هنا بلش ينحذفلما اضيف ال lang وال token
      'Content-Type':'application/json',
      'lang':lang,
      'Authorization':token??'',
    };
    return await dio.post(url,queryParameters: query,data: data);
  }


  static Future<Response?> putData ({
    required String url,
    Map<String,dynamic>? query,
    required Map<String,dynamic> data,
    String lang = 'en',
    String? token,
  })async
  {
    // حجات متغيرة بتكون بال header في postman  بقدرش احطها فوق ف يحطها بفانكشن عشان اقدر اتعامل معها بمتغير
    dio.options.headers={
      // هاد ثابت بس معلش خليه هنا بلش ينحذفلما اضيف ال lang وال token
      'Content-Type':'application/json',
      'lang':lang,
      'Authorization':token??'',
    };
    return await dio.put(url,queryParameters:query,data: data);
  }
}


