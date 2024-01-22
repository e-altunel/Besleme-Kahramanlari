// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:beslemekahramanlari/components/userInfo.dart';
import 'package:http/http.dart' as http;
import 'package:beslemekahramanlari/API/api.dart';
import 'dart:convert';
import 'package:beslemekahramanlari/pages/splash.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  void _changePassword() async {
    if (_newPasswordController.text == _confirmNewPasswordController.text) {
      http.Response response = await Backend.changePassword(
        _oldPasswordController.text,
        _newPasswordController.text,
      );

      Navigator.pop(context); // Close the modal bottom sheet first

      if (response.statusCode == 200) {
        // Password change is successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Password successfully changed"),
            backgroundColor: Color.fromARGB(255, 3, 255, 3),
          ),
        );
      } else {
        // Handle error responses
        var responseData = json.decode(response.body);
        if (responseData['error'] == 'Old Password is wrong') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Old Password is incorrect"),
            ),
          );
        }
        if (responseData['error'] == 'Old and New Passwords are same') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Old and New Passwords are same"),
            ),
          );
        } else {
          // Handle other types of errors
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("An error occurred"),
            ),
          );
        }
      }
    } else {
      Navigator.pop(context); // Close the modal bottom sheet first
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("New Password and Confirmation Password do not match"),
        ),
      );
    }
  }

  void _showChangePasswordModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Current Password"),
              ),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "New Password"),
              ),
              TextField(
                controller: _confirmNewPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Confirm New Password"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text("Change Password"),
                onPressed: _changePassword,
              ),
            ],
          ),
        );
      },
    );
  }

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
            onPressed: () {},
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
                  child: Text(
                    '#' + UserInfo.username,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    SizedBox(width: 8),
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
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          UserInfo.email,
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.blue,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
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
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: ElevatedButton(
                      child: Text("Change Password"),
                      onPressed: () => _showChangePasswordModal(context),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 50, horizontal: 1),
                  child: ElevatedButton(
                    child: Text("Logout"),
                    onPressed: (){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Splash(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
