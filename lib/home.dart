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
        image: eachItem['image'],
        category: eachItem['category'],
        price: eachItem['price'].toDouble(),
      );

      this.items.add(items);
    }
    print(items.length);
    print(items[0].price);
  }

  @override
  Widget build(BuildContext context) {
    getItems();
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      body: FutureBuilder(
        future: getItems(),
        builder: ((context, snapshot) {
          //loading bittiyse
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(itemBuilder: ((context, index) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  width: 200,
                  height: 500,
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 32, bottom: 64.0),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  items[index].image ?? "",
                                  height: 300,
                                  width: 200,
                                )),
                          ),
                          ListTile(
                            title: Text(
                              items[index].title ?? "",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18),
                            ),
                            leading: Text(
                              items[index].category!.toUpperCase(),
                              style: const TextStyle(color: Colors.indigo),
                            ),
                            subtitle: Text(
                              "\$ ${items[index].price}",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 24),
                            ),
                          )
                        ],
                      )),
                ),
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
