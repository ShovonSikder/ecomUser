import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomuser/models/user_model.dart';
import 'package:ecomuser/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../auth/authservice.dart';
import 'launcher_page.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errMsg = '';
  late UserProvider userProvider;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    userProvider = Provider.of<UserProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      filled: true,
                      prefixIcon: Icon(Icons.email),
                      labelText: 'Email Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Provide a valid email address';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextFormField(
                  controller: _passwordController,
                  //obscureText: true,
                  decoration: const InputDecoration(
                      filled: true,
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'Password(at least 6 characters)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Provide a valid password';
                    }
                    return null;
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _authenticate(true);
                },
                child: const Text('Login'),
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
                      'Register here',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errMsg,
                  style: const TextStyle(fontSize: 18, color: Colors.red),
                ),
              ),
              ListTile(
                onTap: () {
                  _signInWithGoogle();
                },
                leading: const Icon(
                  Icons.g_mobiledata,
                  size: 30,
                  color: Colors.brown,
                ),
                title: const Text('Sign in with Google'),
              ),
              TextButton(onPressed: () {}, child: Text('Login as Guest')),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _authenticate(bool tag) async {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show(status: 'Please wait', dismissOnTap: false);
      final email = _emailController.text;
      final password = _passwordController.text;
      try {
        if (tag) {
          await AuthService.login(email, password);
        } else {
          await AuthService.register(email, password);
        }

        if (!tag) {
          final userModel = UserModel(
              userId: AuthService.currentUser!.uid,
              email: AuthService.currentUser!.email!,
              userCreationTime: Timestamp.fromDate(
                  AuthService.currentUser!.metadata.creationTime!));
          userProvider.addUser(userModel).then((value) {
            EasyLoading.dismiss();
            if (mounted) {
              Navigator.pushReplacementNamed(context, LauncherPage.routeName);
            }
          });
        }

        EasyLoading.dismiss();
        if (mounted) {
          Navigator.pushReplacementNamed(context, LauncherPage.routeName);
        }
      } on FirebaseAuthException catch (error) {
        EasyLoading.dismiss();
        setState(() {
          _errMsg = error.message!;
        });
      }
    }
  }

  void _signInWithGoogle() async {
    EasyLoading.show(status: 'Please wait...');
    try {
      final credential = await AuthService.signInWithGoogle();
      final userExist = await userProvider.doesUserExist(credential.user!.uid);
      EasyLoading.dismiss();

      if (!userExist) {
        EasyLoading.show(status: 'Redirecting user...');
        final userModel = UserModel(
          userId: credential.user!.uid,
          email: credential.user!.email!,
          userCreationTime: Timestamp.fromDate(
              AuthService.currentUser!.metadata.creationTime!),
          displayName: credential.user!.displayName,
          imageUrl: credential.user!.photoURL,
          phone: credential.user!.phoneNumber,
        );
        await userProvider.addUser(userModel);
      }
      if (mounted) {
        EasyLoading.dismiss();
        Navigator.pushReplacementNamed(context, LauncherPage.routeName);
      }
    } catch (error) {
      EasyLoading.dismiss();
    }
  }
}
