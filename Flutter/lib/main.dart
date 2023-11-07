import 'package:flutter/material.dart';
import 'homePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            elevation: 1, color: const Color.fromARGB(225, 245, 59, 2)),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomePage(),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Spacer(),
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
                        ? Color.fromARGB(255, 245, 59, 2)
                        : Color.fromARGB(255, 0, 0, 0))),
            Spacer(),
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
                        ? Color.fromARGB(255, 245, 59, 2)
                        : Color.fromARGB(255, 0, 0, 0))),
            Spacer(),
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
                      : Color.fromARGB(255, 0, 0, 0),
                )),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
