import 'package:ecom_user/providers/user_provider.dart';
import 'package:ecom_user/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatelessWidget {
  static const String routeName = '/userprofile';

  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text('My Profile'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) => ListView(
          children: [
            buildProfileCover(provider),
            buildDisplayName(provider, context),
            buildPhoneNumber(provider, context),
          ],
        ),
      ),
    );
  }

  ListTile buildPhoneNumber(UserProvider provider, BuildContext context) {
    return ListTile(
      title: Text(
        provider.appUser?.phoneNumber ?? 'Phone number not found',
        style: const TextStyle(fontSize: 18),
      ),
      trailing: IconButton(
        onPressed: () {
          showSingleTextInputDialog(
            context: context,
            title: 'Edit phone number',
            onSave: (value) async {
              await provider.updateUserPhoneNumber(value);
              showMsg(context, 'phone number updated');
            },
          );
        },
        icon: const Icon(Icons.edit_outlined),
      ),
    );
  }

  ListTile buildDisplayName(UserProvider provider, BuildContext context) {
    return ListTile(
      title: Text(
        provider.appUser?.displayName ?? 'Name not found',
        style: const TextStyle(fontSize: 18),
      ),
      trailing: IconButton(
        onPressed: () {
          showSingleTextInputDialog(
            context: context,
            title: 'Edit Name',
            onSave: (value) async {
              await provider.updateUserDisplayName(value);
              showMsg(context, 'display name updated');
            },
          );
        },
        icon: const Icon(Icons.edit_outlined),
      ),
    );
  }

  SizedBox buildProfileCover(UserProvider provider) {
    return SizedBox(
      height: 150,
      child: Card(
        child: Center(
          child: Row(
            children: [
              const Icon(
                Icons.person_outline_rounded,
                size: 100,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.appUser?.displayName ?? 'Name not set yer',
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    provider.appUser?.email ?? 'Email not set yet',
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    provider.appUser?.phoneNumber ?? 'Phone not set yet',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
