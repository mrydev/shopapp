import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopapp/models.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<shopitems> items = [];

//get items
  Future getItems() async {
    var response = await http.get(Uri.https('fakestoreapi.com', 'products'));
    var jsonData = jsonDecode(response.body);

    for (var eachItem in jsonData) {
      final items = shopitems(
        title: eachItem['title'],
      );
      this.items.add(items);
    }
    print(items.length);
  }

  @override
  Widget build(BuildContext context) {
    getItems();
    return Scaffold(
      body: FutureBuilder(
        future: getItems(),
        builder: ((context, snapshot) {
          //loading bittiyse
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(itemBuilder: ((context, index) {
              return ListTile(
                title: Text(items[index].title.toString()),
              );
            }));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
    );
  }
}
