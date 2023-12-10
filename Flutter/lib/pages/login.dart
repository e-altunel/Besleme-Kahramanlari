import "package:flutter/material.dart";
import '../components/my_textfield.dart';
import '../components/my_button.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in
  void SignUserIn() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/animas.jpg'),
        fit: BoxFit.cover,
      )),
      child: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'Besleme Kahramanlari',
                  style: TextStyle(
                    fontFamily: 'LilitaOne',
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Icon(
                Icons.pets,
                color: Colors.red,
                size: 100,
              ),
              const SizedBox(height: 30),
              const Text("Welcome Back",
                  style: TextStyle(color: Colors.grey, fontSize: 16)),
              const SizedBox(height: 25),
              MyTextField(
                controller: usernameController,
                hintText: "Username",
                obscureText: false,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: passwordController,
                hintText: "Password",
                obscureText: true,
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              MyButton(onTap: SignUserIn),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  SizedBox(width: 5),
                  Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
