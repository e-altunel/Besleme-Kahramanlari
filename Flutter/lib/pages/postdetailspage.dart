import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // DateFormat için gerekli
import 'package:http/http.dart' as http;
import 'package:beslemekahramanlari/components/post.dart';
import 'package:beslemekahramanlari/API/api.dart';

class PostDetailsPage extends StatelessWidget {
  final Post post;

  PostDetailsPage({required this.post});

  void _reportPost(BuildContext context) async {
    try {
      http.Response response = await Backend.reportPost(post.pk);
      if (response.statusCode == 200) {
        // Successfully reported
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Successfully reported the post.")),
        );
      } else {
        // Error in reporting
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You already reported the Post!")),
        );
      }
    } catch (e) {
      // Exception handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred Check your connection.")),
      );
    }
  }

  String _formatDateTime(String dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr);
    return '${DateFormat('dd/MM/yyyy').format(dateTime)}\n${DateFormat('HH:mm').format(dateTime)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: Backend.getFeedPoint(post.feedPoint),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                http.Response response = snapshot.data as http.Response;
                if (response.statusCode == 200) {
                  var feedPointData = json.decode(response.body);
                  String feedPointName =
                      feedPointData['feed_point']['name']; // Burası güncellendi
                  return _buildPostDetails(feedPointName, context);
                } else {
                  return Text('Error: Unable to fetch feed point data');
                }
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _reportPost(context),
        icon: Icon(Icons.report),
        label: Text('Report!'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        tooltip: 'Report this post',
      ),
    );
  }

  Widget _buildPostDetails(String feedPointName, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Stack(
            children: <Widget>[
              Image.network(
                Uri.parse(url).origin + post.imageUrl,
                fit: BoxFit.cover,
                width: MediaQuery.of(context)
                    .size
                    .width, // Sayfa genişliğine göre ayarlar
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Text(
                  '#${post.username}\n',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Metin rengi
                    backgroundColor: Colors.black45, // Arkaplan rengi
                  ),
                ),
              ),
              Positioned(
                top: 40,
                right: 10,
                child: Text(
                  '📍$feedPointName',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Metin rengi
                    backgroundColor: Colors.black45, // Arkaplan rengi
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Text(
                  '🍗${post.foodAmount} gr.',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Metin rengi
                    backgroundColor: Colors.black45, // Arkaplan rengi
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _formatDateTime(post.createdAt), // Tarih formatı güncellendi
                style: TextStyle(
                  fontFamily: 'LilitaOne',
                  fontSize: 20,
                  color: Colors.red[500],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
