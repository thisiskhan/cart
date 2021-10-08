import 'package:flutter/material.dart';
import 'package:flutter_cart_sample/Model/cart.dart';
import 'package:flutter_cart_sample/Model/catalog.dart';
import 'package:flutter_cart_sample/Provider/cart_provider.dart';
import 'package:flutter_cart_sample/Screens/cart_screen.dart';
import 'package:flutter_cart_sample/Screens/catalog_screen.dart';
import 'package:flutter_cart_sample/common/theme.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Using MultiProvider is convenient when providing multiple objects.
    return MultiProvider(
      providers: [
        // In this sample app, CatalogModel never changes, so a simple Provider
        // is sufficient.
        Provider(create: (context) => CatalogModel()),
        // CartModel is implemented as a ChangeNotifier, which calls for the use
        // of ChangeNotifierProvider. Moreover, CartModel depends
        // on CatalogModel, so a ProxyProvider is needed.
        ChangeNotifierProxyProvider<CatalogModel, CartModel>(
          create: (context) => CartModel(),
          update: (context, catalog, cart) {
            if (cart == null) throw ArgumentError.notNull('cart');
            cart.catalog = catalog;
            return cart;
          },
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'flutter_cart',
        theme: appTheme,
        home: MyCatalog(),
        initialRoute: '/catalog',
        routes: {
          // '/': (context) => MyLogin(),
          '/catalog': (context) => MyCatalog(),
          '/cart': (context) => MyCart(),
        },
      ),
    );
  }
}
