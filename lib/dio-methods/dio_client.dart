import 'package:dio/dio.dart';
import 'package:first/model/post_model.dart';
import 'package:flutter/material.dart';

class DioClient {
static Dio dio = Dio();
static const baseUrl = "http://jsonplaceholder.typicode.com";
static const postsEndpoint = baseUrl + "/posts";


Future<Post> fetchPost (int postId) async {
 try {
  //http://jsonplaceholder.typicode.com/posts/1
  final response = await dio.get(postsEndpoint + "/$postId");
  //http://jsonplaceholder.typicode.com/posts?id=1
  debugPrint(response.toString());
  return Post.fromJson(response.data);
 } on DioError catch (e){
  debugPrint("Status code ${e.response?.statusCode.toString()}");
  throw Exception("Failed to load post : $postId");
 }
}

Future<List<Post>> fetchPosts() async {
  try{
    final response = await dio.get(postsEndpoint);
    return Post.listFromJson(response.data);
    debugPrint(response.toString());
  } on DioError catch (e){
    debugPrint("Status code ${e.response?.statusCode.toString()}");
    throw Exception("Failed to load posts");
  }
}

Future<Post> createPost(int userId, String title, String body) async {
  try{
    final response = await dio.post(postsEndpoint,data: {
      "userId": userId,
      "title": title,
      "body": body,
    },);
    debugPrint(response.toString());
    return Post.fromJson(response.data);
  } on DioError catch (e) {
    debugPrint("Status code ${e.response?.statusCode.toString()}");
    throw Exception("Failed to create Post");
  }
}
Future<Post> updatePost(
  int postId, int userId, String title, String body
) async {
  try{
    final response = await dio.put(postsEndpoint + "/$postId",data: {
      "userId": userId,
      "title": title,
      "body": body,
    },);
    debugPrint(response.toString());
    return Post.fromJson(response.data);
  } on DioError catch (e) {
    debugPrint('Status code: ${e.response?.statusCode.toString()}');
  throw Exception("Failed to update Post");
  }
}

Future<void> deletePost (int postId) async {
  try {
    await dio.delete(postsEndpoint+ "/$postId");
    debugPrint("Delete success");
  } on DioError catch (e){
    debugPrint("Status code: ${e.response?.statusCode.toString()}");
    throw Exception("Failed to delete post : $postId");
  }
}


}