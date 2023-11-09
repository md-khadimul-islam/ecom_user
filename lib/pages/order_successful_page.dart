import 'package:ecom_user/pages/launcher_screen.dart';
import 'package:ecom_user/utils/custom_button.dart';
import 'package:flutter/material.dart';

class OrderSuccessfulPage extends StatelessWidget {
  static const String routeName = '/successful';

  const OrderSuccessfulPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Placed'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.done_outline_sharp,
              size: 150,
              color: Colors.amber,
            ),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Your order has been placed',
                style: TextStyle(fontSize: 20),
              ),
            ),
            CustomButton(
              title: 'BACK TO HOME',
              onPressed: () => Navigator.pushReplacementNamed(context, LauncherScreen.routeName),
            ),
          ],
        ),
      ),
    );
  }
}
