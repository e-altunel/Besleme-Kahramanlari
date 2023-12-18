// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:beslemekahramanlari/components/userInfo.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: Text(
          'Besleme Kahramanlari',
          style: TextStyle(
            fontFamily: 'LilitaOne',
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              size: 35,
              Icons.account_circle,
              color: Colors.red[1000],
            ),
            onPressed: () {
              // Profil ikonuna tıklanınca yapılacak işlemler
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/animas.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 25),
                Center(
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage('assets/pp.jpg'),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    SizedBox(width: 8),
                    Text(
                      '          #' + UserInfo.username,
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 90),
                Row(
                  children: [
                    Icon(Icons.person, size: 30),
                    SizedBox(width: 8),
                    Text(
                      UserInfo.first_name + ' ' + UserInfo.last_name,
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.mail, size: 30, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      UserInfo.email,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.restaurant, size: 30),
                    SizedBox(width: 8),
                    Text(
                      'Total Feeding: ' +
                          UserInfo.food_amount.toString() +
                          ' gr.',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Edit butonuna basıldığında bir şey yapma
        },
        child: Icon(Icons.edit, color: Colors.red),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
