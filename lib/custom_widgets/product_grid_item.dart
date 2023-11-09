import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_user/models/product_model.dart';
import 'package:ecom_user/pages/product_details_page.dart';
import 'package:ecom_user/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    return InkWell(
      onTap: () => Navigator.pushNamed(context, ProductDetailsPage.routeName, arguments: product.id),
      child: Card(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  CachedNetworkImage(
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
                  if(product.discount > 0)Container(
                    alignment: Alignment.center,
                    height: 50,
                    color: Colors.black38,
                    child: Text('${product.discount}% OFF', style: const TextStyle(fontSize: 25, color: Colors.white),),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                product.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            if (product.discount > 0)
              RichText(
                text: TextSpan(
                    text: '$currencySymbol${product.price} ',
                    style: const TextStyle(
                        fontSize: 18,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.red),
                    children: [
                      TextSpan(
                          text:
                              '$currencySymbol${provider.priceAfterDiscount(product.price, product.discount)}',
                          style: const TextStyle(
                              fontSize: 25,
                              decoration: TextDecoration.none,
                              color: Colors.black)),
                    ]),
              ),
            if (product.discount == 0)
              Text(
                '$currencySymbol${product.price}',
                style: const TextStyle(fontSize: 25),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${product.avgRating}  '),
                RatingBar.builder(
                  onRatingUpdate: (value) {},
                  itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber,),
                  ignoreGestures: true,
                  itemSize: 25,
                  allowHalfRating: true,
                  initialRating: product.avgRating,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
