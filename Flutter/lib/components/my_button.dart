import "package:flutter/material.dart";

class MyButton extends StatelessWidget {
  final void Function()? onTap;

  const MyButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(15.0),
        margin: const EdgeInsets.symmetric(horizontal: 15.0),
        decoration: BoxDecoration(
          color: Color.fromARGB(224, 0, 0, 0),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          "Sign In",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
