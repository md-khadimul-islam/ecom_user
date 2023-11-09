import 'package:ecom_user/pages/launcher_screen.dart';
import 'package:ecom_user/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import '../utils/custom_button.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isObscure = true;
  String errMsg = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 40.0, vertical: 4.0),
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email Address',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This filed must not be empty';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 40.0, vertical: 4.0),
                    child: TextFormField(
                      obscureText: isObscure,
                      controller: _passwordController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isObscure = !isObscure;
                              });
                            },
                            icon: Icon(isObscure
                                ? Icons.visibility_off
                                : Icons.visibility)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This filed must not be empty';
                        }
                        return null;
                      },
                    ),
                  ),
                  CustomButton(
                    title: 'LOG IN',
                    onPressed: () {
                      _authenticate(true);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('New User?'),
                      TextButton(
                        onPressed: () {
                          _authenticate(false);
                        },
                        child: const Text(
                          'Register Here',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  const Center(
                    child: Text(
                      'OR',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))),
                      onPressed: _googleSignIn,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset('images/google.png', width: 20, height:20,),
                          const Text('SIGN IN WITH GOOGLE'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))),
                      onPressed: _facebookSignIn,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset('images/facebook.png', width: 25, height: 25,),
                          const Text('SIGN IN WITH FACEBOOK'),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      errMsg,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _authenticate(bool isLogin) async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;
      EasyLoading.show(status:  'Please wait');
      User user;
      try{
        if (isLogin) {
          user = await AuthService.loginUser(email, password);
        }
        else {
          user = await AuthService.registerUser(email, password);
          await Provider.of<UserProvider>(context, listen: false).addNewUser(user);
        }
        EasyLoading.dismiss();
        Navigator.pushReplacementNamed(context, LauncherScreen.routeName);
      } on FirebaseException catch (error) {
        EasyLoading.dismiss();
        setState(() {
          errMsg = error.message!;
        });

      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _googleSignIn() async {
    final userCredential = await AuthService.signInWithGoogle();
    final exist = await AuthService.doesUserExist();
    if(!exist) {
      await Provider.of<UserProvider>(context, listen: false).addNewUser(userCredential.user!);
    }
    Navigator.pushReplacementNamed(context, LauncherScreen.routeName);
  }

  void _facebookSignIn() async {
    final userCredential = await AuthService.signInWithFacebook();
    final exist = await AuthService.doesUserExist();
    if(!exist) {
      await Provider.of<UserProvider>(context, listen: false).addNewUser(userCredential.user!);
    }
    Navigator.pushReplacementNamed(context, LauncherScreen.routeName);
  }
}
