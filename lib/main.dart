import 'package:flutter/material.dart';
import 'package:sqflite_demo/database/product_database.dart';
import 'package:sqflite_demo/models/product.dart';
import 'package:sqflite_demo/widgets/product_card.dart';
import 'package:sqflite_demo/widgets/product_info_widget.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late Future<List<Product>?> futureProducts;
  final ProductDatabase db = ProductDatabase();

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  void fetchData() {
    setState(() {
      futureProducts = db.getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Product"),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => showDialog(
              context: context,
              builder: (_) => ProductInfoWidget(
                    onSubmit: (product) async {
                      await db.addProduct(product);
                      if (!mounted) return;
                      fetchData();
                      Navigator.of(context).pop();
                    },
                  )),
        ),
        // body: FutureBuilder(
        //     future: futureProducts,
        //     builder: (context, snapshot) {
        //       if (snapshot.connectionState == ConnectionState.waiting) {
        //         return const Center(
        //           child: CircularProgressIndicator(),
        //         );
        //       }

        //       final products = snapshot.data!;
        //       if (products.isEmpty) {
        //         return const Center(
        //           child: Text("No product found."),
        //         );
        //       }

        //       return Column(
        //         children: productCardList(products),
        //       );
        //     }),
      ),
    );
  }

  List<Widget> productCardList(List<Product> products) {
    List<Widget> cardList = [];

    for (Product p in products) {
      cardList.add(ProductCard(product: p));
    }

    return cardList;
  }
}
