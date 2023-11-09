import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_user/custom_widgets/main_drawer.dart';
import 'package:ecom_user/pages/cart_page.dart';
import 'package:ecom_user/providers/cart_provider.dart';
import 'package:ecom_user/providers/product_provider.dart';
import 'package:ecom_user/utils/custom_button.dart';
import 'package:ecom_user/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ProductDetailsPage extends StatelessWidget {
  static const String routeName = '/details';

  const ProductDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final id = ModalRoute.of(context)!.settings.arguments as String;
    final product = productProvider.getProductById(id);
    double rating = 1.5;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          CachedNetworkImage(
            width: double.infinity,
            height: 300,
            fadeInDuration: const Duration(seconds: 2),
            fadeInCurve: Curves.bounceInOut,
            imageUrl: product.imageUrl,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Center(
              child: Icon(Icons.error_outline_outlined),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Consumer<CartProvider>(builder: (context, provider, child) {
            final isInCart = provider.isInCart(product.id!);
            return Center(
              child: SizedBox(
                height: 60,
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      backgroundColor: Colors.blueGrey.shade900,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      EasyLoading.show(status: 'Please wait');
                      if (isInCart) {
                        await provider.removeFromCart(product.id!);
                        showMsg(context, 'Deleted cart Item');
                      } else {
                        await provider.addToCart(
                            product,
                            productProvider.priceAfterDiscount(
                                product.price, product.discount));
                        showMsg(context, 'Added to cart');
                      }
                      EasyLoading.dismiss();
                    },
                    icon: Icon(isInCart
                        ? Icons.remove_shopping_cart_outlined
                        : Icons.shopping_cart_outlined),
                    label: Text(
                      isInCart ? 'REMOVE FROM CART' : 'ADD TO CART',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            );
          }),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RatingBar.builder(
                    onRatingUpdate: (value) {
                      rating = value;
                    },
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemSize: 40,
                    allowHalfRating: true,
                    initialRating: 1.5,
                    minRating: 1.5,
                  ),
                  CustomButton(
                    title: 'SUBMIT',
                    onPressed: () async {
                      EasyLoading.show(status: 'Please wait');
                      await productProvider.addRating(id, rating);
                      await productProvider.updateAvgRatingForProduct(id);
                      EasyLoading.dismiss();
                      showMsg(context, 'Thanks for your rating');
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            children: [
              CustomButton(
                title: 'BUY NOW',
                onPressed: () {
                  Navigator.pushReplacementNamed(context, CartPage.routeName);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
