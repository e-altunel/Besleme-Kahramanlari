import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:beslemekahramanlari/API/api.dart';
import 'package:beslemekahramanlari/components/post.dart';
import 'package:beslemekahramanlari/pages/postdetailspage.dart';

class DiscoveryPage extends StatefulWidget {
  @override
  _DiscoveryPageState createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {
  List<Post> posts = [];
  final String baseUrl = "http://159.146.103.199:8000";

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  void _fetchPosts() async {
    try {
      http.Response response = await Backend.getLatestPosts();
      if (response.statusCode == 200) {
        setState(() {
          var responseData = json.decode(response.body);
          posts = (responseData['posts'] as List)
              .take(8)
              .map<Post>((json) => Post.fromJson(json))
              .toList();
        });
      } else {
        // Handle error
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // geri gitme butonu iptal
        title: Text(
          'Recent Posts',
          style: TextStyle(
            fontFamily: 'LilitaOne',
            fontSize: 25,
            color: Colors.red,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchPosts,
          )
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          var post = posts[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostDetailsPage(post: post),
                ),
              );
            },
            child: Image.network(
              baseUrl + post.imageUrl,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
