import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Besleme Kahramanları"),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.person))],
        backgroundColor: const Color.fromARGB(255, 252, 81, 2),
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage(
                "lib/images/beslemekahramanlarilogo.png"), // Resim dosyanızın yolunu belirtin
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            const Spacer(),
            IconButton(
                onPressed: () {
                  setState(
                    () {
                      currentPage = 0;
                    },
                  );
                },
                icon: Icon(Icons.maps_home_work_sharp,
                    color: currentPage == 0
                        ? const Color.fromARGB(255, 245, 59, 2)
                        : const Color.fromARGB(255, 0, 0, 0))),
            const Spacer(),
            IconButton(
                onPressed: () {
                  setState(
                    () {
                      currentPage = 1;
                    },
                  );
                },
                icon: Icon(Icons.location_pin,
                    color: currentPage == 1
                        ? const Color.fromARGB(255, 245, 59, 2)
                        : const Color.fromARGB(255, 0, 0, 0))),
            const Spacer(),
            IconButton(
                onPressed: () {
                  setState(
                    () {
                      currentPage = 2;
                    },
                  );
                },
                icon: Icon(
                  Icons.search,
                  color: currentPage == 2
                      ? const Color.fromARGB(255, 245, 59, 2)
                      : const Color.fromARGB(255, 0, 0, 0),
                )),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
