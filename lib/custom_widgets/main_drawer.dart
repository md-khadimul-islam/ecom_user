import 'package:ecom_user/auth/auth_service.dart';
import 'package:ecom_user/pages/cart_page.dart';
import 'package:ecom_user/pages/launcher_screen.dart';
import 'package:ecom_user/pages/user_order_page.dart';
import 'package:ecom_user/pages/user_profile_page.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 250,
            color: Colors.grey,
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, UserProfilePage.routeName);
            },
            leading: const Icon(Icons.person),
            title: const Text('My Profile'),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, CartPage.routeName);
            },
            leading: const Icon(Icons.shopping_cart_outlined),
            title: const Text('My Cart'),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, UserOrderPage.routeName);
            },
            leading: const Icon(Icons.monetization_on_outlined),
            title: const Text('My Orders'),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              AuthService.logout().then((value) =>
                  Navigator.pushReplacementNamed(
                      context, LauncherScreen.routeName));
            },
            leading: const Icon(Icons.logout_outlined),
            title: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
