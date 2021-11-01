import 'package:flutter/material.dart';
import 'package:loja_virtual/tab/home_tab.dart';
import 'package:loja_virtual/widget/cart_button.dart';
import 'package:loja_virtual/widget/custom_drawe.dart';
import 'package:loja_virtual/tab/products_tab.dart';
import 'package:loja_virtual/tab/orders_tab.dart';
import 'package:loja_virtual/tab/places_tab.dart';

class HomeScrean extends StatelessWidget {
  HomeScrean({Key key}) : super(key: key);

  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Scaffold(
            body: HomeTab(),
            drawer: CustomDrawer(pageController),
            floatingActionButton: CartButton(),
          ),
          Scaffold(
              appBar: AppBar(
                title: Text("Produtos"),
                centerTitle: true,
              ),
              drawer: CustomDrawer(pageController),
              body: ProductsTab(),
              floatingActionButton: CartButton()),
          Scaffold(
            appBar: AppBar(
              title: Text("Lojas"),
              centerTitle: true,
            ),
            body: PlacesTab(),
            drawer: CustomDrawer(pageController),
          ),
          Scaffold(
            appBar: AppBar(
              title: Text("Meus Pedidos"),
              centerTitle: true,
            ),
            body: OrdersTab(),
            drawer: CustomDrawer(pageController),
          )
        ]);
  }
}
