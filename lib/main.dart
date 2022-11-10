import 'package:ecomuser/pages/otp_verification_page.dart';
import 'package:ecomuser/pages/user_profile_page.dart';
import 'package:ecomuser/providers/order_provider.dart';
import 'package:ecomuser/providers/product_provider.dart';
import 'package:ecomuser/providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'pages/add_product_page.dart';
import 'pages/category_page.dart';
import 'pages/launcher_page.dart';
import 'pages/login_page.dart';
import 'pages/order_page.dart';
import 'pages/product_details_page.dart';
import 'pages/report_page.dart';
import 'pages/settings_page.dart';
import 'pages/view_product_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ProductProvider()),
    ChangeNotifierProvider(create: (_) => OrderProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      builder: EasyLoading.init(),
      initialRoute: LauncherPage.routeName,
      routes: {
        LauncherPage.routeName: (context) => const LauncherPage(),
        LoginPage.routeName: (context) => const LoginPage(),
        AddProductPage.routeName: (context) => const AddProductPage(),
        ViewProductPage.routeName: (context) => const ViewProductPage(),
        ProductDetailsPage.routeName: (context) => ProductDetailsPage(),
        CategoryPage.routeName: (context) => const CategoryPage(),
        OrderPage.routeName: (context) => const OrderPage(),
        ReportPage.routeName: (context) => const ReportPage(),
        SettingsPage.routeName: (context) => const SettingsPage(),
        UserProfilePage.routeName: (context) => const UserProfilePage(),
        OtpVerificationPage.routeName: (context) => const OtpVerificationPage(),
      },
    );
  }
}
