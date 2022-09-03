import 'package:first/dio-methods/dio_client.dart';
import 'package:first/model/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DioExample extends StatefulWidget {
  const DioExample({super.key});

  @override
  State<DioExample> createState() => _DioExampleState();
}

class _DioExampleState extends State<DioExample> {
  var requesting = false;
  late DioClient dioClient;
  late Future<Post> post;
  late Future<List<Post>> posts;

  @override
  void initState() {
    // TODO: implement initState
    
    super.initState();
    dioClient = DioClient();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      if(requesting)
        // FutureBuilder(future: post,builder: (context,snapshot){
        //   if(snapshot.hasData){
        //     return Padding(padding: const EdgeInsets.all(24), child: Column(children: [
        //       Text("Title : ${snapshot.data!.title}"),
        //       SizedBox(height: 20,),
        //       Text("Body: ${snapshot.data!.body}")

        //     ]),);
        //   }
        //   else if(snapshot.hasError) {
        //     return Text('${snapshot.error}');
        //   }
        //   return const CircularProgressIndicator();
        // }),
        // FutureBuilder<List<Post>>(future: posts,builder: (context, snapshot) {
        //   if(snapshot.hasData){
        //     return Padding(padding: const EdgeInsets.all(24),child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
        //       Text('Title: ${snapshot.data![13].title}'),
        //       Text('Body: ${snapshot.data![12].body}'),
        //       const SizedBox(height: 24,),
        //       Text('Title: ${snapshot.data![1].title}'),
        //       Text('Body: ${snapshot.data![1].body}'),

        //     ],) ,);
        //   }
        //   else if(snapshot.hasError){
        //     return Text('${snapshot.error}');
        //   }
        //   return CircularProgressIndicator();
        // },),
        FutureBuilder<Post> (future: post, builder: (context, snapshot) {
          if(snapshot.hasData){
            return Padding(padding: const EdgeInsets.all(24),child: Column(children: [
              Text('Title: ${snapshot.data!.title}'),
              Text('body: ${snapshot.data!.body}'),
            ]),);
          }
          else if(snapshot.hasError){
            return Text('${snapshot.error}');
          }
          return CircularProgressIndicator();
        },),
        Center(child: Wrap(spacing: 10, alignment: WrapAlignment.center,children: [
          ElevatedButton(onPressed: (){
            post = dioClient.fetchPost(101);
            setState(() {
              requesting = true;
            });
          }, child: const Text("Get Post")),
          ElevatedButton(onPressed: (){
            posts = dioClient.fetchPosts();
            setState(() {
              requesting = true;
            });
          }, child: const Text("Get Posts")),
          ElevatedButton(onPressed: (){
            post = dioClient.createPost(1, 'test title', 'testbody');
            setState(() {
              requesting = true;
            });
          }, child: const Text("Create Post")),
          ElevatedButton(onPressed: (){
            post = dioClient.updatePost(1,1, 'update title', 'update body');
            setState(() {
              requesting = true;
            });
          }, child: const Text("Update Post")),
          ElevatedButton(onPressed: (){
            dioClient.deletePost(1);
            setState(() {
              requesting = true;
            });
          }, child: const Text("Delete Post"))
        ],),),
        
    ],),
    );
  }
}