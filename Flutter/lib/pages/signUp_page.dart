import 'dart:convert';

import 'package:beslemekahramanlari/API/api.dart';
import 'package:beslemekahramanlari/components/userInfo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
              ),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Perform signup logic here
                String firstName = firstNameController.text;
                String lastName = lastNameController.text;
                String email = emailController.text;
                String username = usernameController.text;
                String password = passwordController.text;

                // You can implement your signup logic here
                // For now, let's print the values

                final response = Backend.register(
                        firstName, lastName, username, email, password)
                    .then((response) {
                  if (response.statusCode == 200) {
                    // Başarılı bir response geldiyse JSON'u parse et
                    Map<String, dynamic> jsonResponse =
                        json.decode(response.body);

                    // Eğer "token" alanı varsa al
                    if (jsonResponse.containsKey("token") &&
                        jsonResponse.containsKey("user")) {
                      Map<String, dynamic> userMap = jsonResponse["user"];
                      UserInfo.token = jsonResponse["token"].toString();
                      UserInfo.username = userMap["username"].toString();
                      UserInfo.pk = userMap["pk"].toString();
                      UserInfo.email = userMap["email"].toString();
                      UserInfo.password = userMap["password"].toString();
                      UserInfo.food_amount = userMap["food_amount"].toString();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Successfully registered!",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                          duration: Duration(seconds: 3),
                          backgroundColor: Color.fromARGB(255, 76, 235, 3),
                        ),
                      );
                    } else {
                      print("Some key is missing in the jsonResponse");
                      // Handle the case where some key is missing in the jsonResponse
                    }
                  } else if (response.statusCode == 400) {
                    // Kullanıcı adı veya e-posta zaten varsa
                    Map<String, dynamic> errorResponse =
                        json.decode(response.body);

                    if (errorResponse.containsKey("username") &&
                        errorResponse['username'][0] ==
                            'user with this username already exists.') {
                      // Kullanıcı adı zaten var
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "User with this username already exists.",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                          duration: Duration(seconds: 3),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else if (errorResponse.containsKey("email") &&
                        errorResponse['email'][0] ==
                            'user with this email already exists.') {
                      // E-posta zaten var
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "User with this email already exists.",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                          duration: Duration(seconds: 3),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } else {
                    // Başarısız bir response durumunda hata işlemleri
                    print('Error during registration: ${response.statusCode}');
                  }
                  print(response.body);
                });

                // You can add additional logic here, such as sending the data to a server for registration.
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
