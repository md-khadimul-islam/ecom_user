import 'dart:io';

import 'package:ecom_user/providers/user_provider.dart';
import 'package:ecom_user/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatefulWidget {
  static const String routeName = '/userprofile';

  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String? localImagePath;

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
              Stack(
                alignment: AlignmentDirectional.centerStart,
                children: [
                  localImagePath == null
                      ? const Icon(
                          Icons.person_outline_rounded,
                          size: 100,
                        )
                      : Image.file(
                          File(localImagePath!),
                          height: 90,
                          width: 90,
                        ),
                  IconButton(
                    onPressed: () async {
                      final imageUrl = await Provider.of<UserProvider>(context,
                              listen: false)
                          .uploadImage(localImagePath!);
                      _getImage(ImageSource.gallery);
                    },
                    icon: const Icon(Icons.camera_alt),
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
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

  void _getImage(ImageSource source) async {
    final file =
        await ImagePicker().pickImage(source: source, imageQuality: 80);
    if (file != null) {
      setState(() {
        localImagePath = file.path;
      });
    }
  }
}
