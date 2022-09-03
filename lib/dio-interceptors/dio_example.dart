import 'package:dio/dio.dart';
import 'package:first/dio-interceptors/dio_interceptors.dart';
import 'package:first/dio-methods/dio_client.dart';
import 'package:first/model/post_model.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DioExample2 extends StatefulWidget {
  const DioExample2({super.key});

  @override
  State<DioExample2> createState() => _DioExample2State();
}

class _DioExample2State extends State<DioExample2> {
  var requesting = false;
  late DioClient dioClient;
  late Future<Post> post;
  late Future<List<Post>> posts;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dioClient = DioClient();
    DioClient.dio.interceptors.add(DioInterceptor());

    //Requesti çözümlemek için custom data kullanabilirsin
    //Objeyi reject edebilirsin
    DioClient.dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      //.request gönderilmeden yapılacak metotlar
      return handler.next(options); //devam et
    },
    onResponse: (response,handler) {
      return handler.next(response);
    },
    onError:(DioError e, handler){
      return handler.next(e);
    }
    ));

    DioClient.dio.interceptors.addAll([]);
    String? refreshToken;
    var tokenDio = Dio();
    DioClient.dio.interceptors.add(QueuedInterceptorsWrapper(
      onRequest: (options, handler) {
        if(refreshToken == null){
          tokenDio.get('/token').then((value) {
            options.headers['refreshToken'] = refreshToken = value.data['data']['token'];
            handler.next(options);
          }).catchError((error, stackTrace){
            handler.reject(error,true);
          });
        }
        else{
          options.headers['refreshToken'] = refreshToken;
          return handler.next(options);
        }
      },
      onError: (e, handler) {
        if(e.response?.statusCode == 401){
          var options = e.response?.requestOptions;
          tokenDio.get('/token').then((value) {
            options?.headers['refreshToken'] = refreshToken = value.data['data']['token'];

          }).then((e) {
            DioClient.dio.fetch(options!).then((value) => handler.resolve(value), onError: (e) {
              handler.reject(e);
            },);
          });
          return;
        }
        return handler.next(e);
      },
    ));
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}