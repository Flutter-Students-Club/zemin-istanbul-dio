import 'package:dio/dio.dart';
import 'package:first/dio-methods/dio_client.dart';

class DioInterceptor extends Interceptor{
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler){
    // User Id yi private endpointe ekle ve izin verildiğini var sayalım
    
    if(!options.path.contains("open")){
      options.queryParameters["userId"] = "xxx";
    }
  //token nedir?
    //tokenin de userla eşleştirildiğini varsayalım 
    //belki shared pref ?
    //istek sunucuya gitmeden headera gönderilir
    options.headers["token"] = "xxx";
  //requesting a refresh token
    if(options.headers["refreshToken"] == null) {
      DioClient.dio.lock();
      Dio _tokenDio = Dio();
      _tokenDio.get('/token').then((value) {
        options.headers['refreshToken'] = value.data['data']['token'];
        handler.next(options);
      }).catchError((error, stackTrace){
        handler.reject(error,true);
      }).whenComplete(() {
        DioClient.dio.unlock();
      });
    }
    //forward the request
    return super.onRequest(options, handler);
  }

  @override
  void onResponse (Response response, ResponseInterceptorHandler handler){
    if(response.statusCode == 200){

    }

    else{}
  //secret bir path içeriyorsa reject edebilirdik!!!
    if(response.requestOptions.baseUrl.contains("secret")){

    }
    return super.onResponse(response, handler);
  }

 @override
 void onError(DioError err, ErrorInterceptorHandler handler){
  switch(err.type){
    case DioErrorType.connectTimeout: {

    }
    break;
    case DioErrorType.receiveTimeout:{

    }
    break;
    case DioErrorType.sendTimeout:{

    }
    break;
    case DioErrorType.cancel:{

    }
    break;
    case DioErrorType.response:{

    }
    break;
    case DioErrorType.other:{

    }
    break;
  }
  super.onError(err, handler);
 } 
}