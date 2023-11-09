import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_user/models/address_model.dart';
import 'package:ecom_user/models/app_user.dart';
import 'package:ecom_user/models/order_model.dart';
import 'package:ecom_user/pages/order_successful_page.dart';
import 'package:ecom_user/pages/product_details_page.dart';
import 'package:ecom_user/providers/cart_provider.dart';
import 'package:ecom_user/providers/order_provider.dart';
import 'package:ecom_user/providers/user_provider.dart';
import 'package:ecom_user/utils/constants.dart';
import 'package:ecom_user/utils/custom_button.dart';
import 'package:ecom_user/utils/helper_functions.dart';
import 'package:ecom_user/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  static const String routeName = '/checkout';

  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late CartProvider cartProvider;
  late UserProvider userProvider;
  late AppUser appUser;
  String? city;
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _zipCodeController = TextEditingController();

  @override
  void didChangeDependencies() {
    cartProvider = Provider.of<CartProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    _getUser();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text('Confirm Order'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          const Text(
            'ITEMS:',
            style: TextStyle(fontSize: 18.0),
          ),
          Card(
            child: Column(
              children: cartProvider.cartList
                  .map((cartModel) => ListTile(
                        title: Text(
                          cartModel.productName,
                          style: const TextStyle(fontSize: 18.0),
                        ),
                        trailing: Text(
                          '${cartModel.quantity} x ${cartModel.price}',
                          style: const TextStyle(fontSize: 18.0),
                        ),
                      ))
                  .toList(),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'TOTAL AMOUNT:',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    '$currencySymbol${cartProvider.getCartSubTotal()}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Delivery Address:',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      items: cities
                          .map(
                            (city) => DropdownMenuItem<String>(
                              value: city,
                              child: Text(city),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          city = value;
                        });
                      },
                      value: city,
                      hint: const Text('Select City'),
                      isExpanded: true,
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field must not be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Street Address',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field must not be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _zipCodeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Zip code',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field must not be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                      title: 'PLACE ORDER',
                      onPressed: _saveOrder,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _zipCodeController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _getUser() async {
    appUser = await userProvider.getUser();
    if (appUser.userAddress != null) {
      setState(() {
        city = appUser.userAddress!.city;
        _addressController.text = appUser.userAddress!.streetAddress;
        _zipCodeController.text = appUser.userAddress!.zipcode;
      });
    }
  }

  void _saveOrder() async {
    if (_formKey.currentState!.validate()) {
      final address = AddressModel(
        streetAddress: _addressController.text,
        city: city!,
        zipcode: _zipCodeController.text,
      );
      appUser.userAddress = address;
      final orderModel = OrderModel(
        orderId: generateOrderId,
        appUser: appUser,
        totalAmount: cartProvider.getCartSubTotal(),
        orderStatus: OrderStatus.pending,
        orderDetails: cartProvider.cartList,
        orderDateTime: Timestamp.fromDate(DateTime.now()),
      );
      EasyLoading.show(status: 'Please wait');
      Provider.of<OrderProvider>(context, listen: false)
          .addOrder(orderModel)
          .then((value) {
        EasyLoading.dismiss();
        showMsg(context, 'Order Saved');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const OrderSuccessfulPage()),
          ModalRoute.withName(ProductDetailsPage.routeName),
        );
      }).catchError((error) {
        EasyLoading.dismiss();
        showMsg(context, error.toString());
      });
    }
  }
}
