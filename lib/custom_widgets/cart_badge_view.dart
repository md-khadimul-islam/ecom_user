import 'package:ecom_user/pages/cart_page.dart';
import 'package:ecom_user/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartBadgeView extends StatelessWidget {
  const CartBadgeView({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, CartPage.routeName),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            size: 30,
          ),
          Positioned(
            top: -10,
            right: 4,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(2.0),
              constraints: const BoxConstraints(
                maxHeight: 20,
                maxWidth: 20,
              ),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: FittedBox(
                child: Consumer<CartProvider>(
                  builder: (context, provider, child) =>  Text(
                    '${provider.totalItemsInCart}',
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
