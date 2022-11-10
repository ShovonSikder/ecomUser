import 'package:flutter/material.dart';

class OtpVerificationPage extends StatefulWidget {
  static const String routeName = '/otp';
  const OtpVerificationPage({Key? key}) : super(key: key);

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  late String phoneNumber;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    phoneNumber = ModalRoute.of(context)!.settings.arguments as String;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                phoneNumber,
                style: Theme.of(context).textTheme.headline5,
              ),
              Text('Verify The Phone Number',
                  style: Theme.of(context).textTheme.headline6),
              const Text(
                  textAlign: TextAlign.center,
                  'An OTP Code will be send to your phone. Don\'t share your OTP with others'),
              OutlinedButton(
                onPressed: () {},
                child: Text(
                  'Verify',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
