import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomuser/models/user_model.dart';
import 'package:ecomuser/providers/order_provider.dart';
import 'package:ecomuser/providers/product_provider.dart';
import 'package:ecomuser/providers/user_provider.dart';
import 'package:ecomuser/utils/helper_functions.dart';
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
  String? redirectTo;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    userProvider = Provider.of<UserProvider>(context, listen: false);
    final args = ModalRoute.of(context)!.settings.arguments;
    redirectTo = args != null ? args as String : null;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                      labelText: 'Password'),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.orange),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'reset here',
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
                shape: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                onTap: () {
                  _signInWithGoogle();
                },
                leading: const Icon(
                  Icons.g_mobiledata,
                  size: 40,
                  color: Colors.brown,
                ),
                title: const Text('Sign in with Google'),
              ),
              const SizedBox(
                height: 5,
              ),
              ListTile(
                shape: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                onTap: () {
                  _loginAsGuest();
                },
                leading: const Icon(
                  Icons.account_circle_sharp,
                  color: Colors.brown,
                ),
                title: const Text('Login As a Guest'),
                subtitle: const Text('Want a tour without any account?'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _authenticate(bool tag) async {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show(status: 'Please wait', dismissOnTap: false);
      final email = _emailController.text;
      final password = _passwordController.text;
      try {
        UserCredential credential;
        if (tag) {
          credential = await AuthService.login(email, password);
        } else {
          if (AuthService.currentUser != null &&
              AuthService.currentUser!.isAnonymous) {
            //turn anonymous account into a real account
            final credential =
                EmailAuthProvider.credential(email: email, password: password);
            await _registerAnonymousUser(credential);
          } else {
            //normal registration
            credential = await AuthService.register(email, password);
            final userModel = UserModel(
              userId: credential.user!.uid,
              email: credential.user!.email!,
              userCreationTime:
                  Timestamp.fromDate(credential.user!.metadata.creationTime!),
            );
            await userProvider.addUser(userModel);
          }
        }
        EasyLoading.dismiss();
        if (mounted) {
          if (redirectTo != null) {
            Navigator.pop(context);
            return;
          }
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
    try {
      if (AuthService.currentUser != null &&
          AuthService.currentUser!.isAnonymous) {
        await AuthService.deleteAccount();
      }
      final credential = await AuthService.signInWithGoogle();
      final userExists = await userProvider.doesUserExist(credential.user!.uid);
      if (!userExists) {
        EasyLoading.show(status: 'Redirecting...');
        final userModel = UserModel(
          userId: credential.user!.uid,
          email: credential.user!.email!,
          displayName: credential.user!.displayName,
          imageUrl: credential.user!.photoURL,
          phone: credential.user!.phoneNumber,
          userCreationTime: Timestamp.fromDate(DateTime.now()),
        );
        await userProvider.addUser(userModel);
        EasyLoading.dismiss();
      }

      EasyLoading.dismiss();
      if (mounted) {
        if (redirectTo != null) {
          resetListeners();
          Navigator.pop(context);
          return;
        }
        Navigator.pushReplacementNamed(context, LauncherPage.routeName);
      }
    } catch (error) {
      EasyLoading.dismiss();
      setState(() {
        _errMsg = error.toString();
      });
    }
  }

  void _loginAsGuest() {
    EasyLoading.show(status: 'Please Wait');
    AuthService.signInAnonymously().then((value) {
      EasyLoading.dismiss();
      Navigator.pushReplacementNamed(context, LauncherPage.routeName);
    }).catchError((error) {
      EasyLoading.dismiss();
    });
  }

  Future<void> _registerAnonymousUser(AuthCredential credential) async {
    try {
      final userCredential = await FirebaseAuth.instance.currentUser
          ?.linkWithCredential(credential);
      print('UID>>>>>>>>: ${userCredential!.user!.uid}');
      if (userCredential!.user != null) {
        final userModel = UserModel(
          userId: userCredential.user!.uid,
          email: userCredential.user!.email!,
          userCreationTime:
              Timestamp.fromDate(userCredential.user!.metadata.creationTime!),
        );
        await userProvider.addUser(userModel);
      }
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      switch (e.code) {
        case "provider-already-linked":
          print("The provider has already been linked to the user.");
          break;
        case "invalid-credential":
          print("The provider's credential is not valid.");
          break;
        case "credential-already-in-use":
          print("The account corresponding to the credential already exists, "
              "or is already linked to a Firebase User.");
          break;
        // See the API reference for the full list of error codes.
        default:
          print("Unknown error.");
      }
    }
  }

  void resetListeners() {
    Provider.of<ProductProvider>(context, listen: false).getAllCategories();
    Provider.of<ProductProvider>(context, listen: false).getAllProducts();
    Provider.of<OrderProvider>(context, listen: false).getOrderConstants();
    Provider.of<UserProvider>(context, listen: false).getUserInfo();
  }
}
