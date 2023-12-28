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

  // Geri kalan fonksiyonlar ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Post Details'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Stack(
                  children: <Widget>[
                    Image.network(
                      'http://159.146.103.199:8000' + post.imageUrl,
                      fit: BoxFit.cover,
                      width: 500, // Sayfa genişliğine göre ayarlar
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Text(
                        '#${post.username}',
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
                      _formatDateTime(
                          post.createdAt), // Tarih formatı güncellendi
                      style: TextStyle(
                        fontFamily: 'LilitaOne',
                        fontSize: 20,
                        color: Colors.red[500],
                      ),
                    ),
                    // Diğer widget'lar ...
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _reportPost(context),
          icon: Icon(Icons.report),
          label: Text('Report!'),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          tooltip: 'Report this post',
        ));
  }
}
