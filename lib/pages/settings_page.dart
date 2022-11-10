import 'package:ecomuser/models/order_constant_model.dart';
import 'package:ecomuser/providers/order_provider.dart';
import 'package:ecomuser/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = '/settings';
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _vatController = TextEditingController();
  final _discountController = TextEditingController();
  final _deliveryCharge = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late OrderProvider orderProvider;
  @override
  void dispose() {
    _vatController.dispose();
    _discountController.dispose();
    _deliveryCharge.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    orderProvider = Provider.of<OrderProvider>(context);
    _discountController.text =
        orderProvider.orderConstantModel.discount.toString();
    _deliveryCharge.text =
        orderProvider.orderConstantModel.deliveryCharge.toString();
    _vatController.text = orderProvider.orderConstantModel.vat.toString();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Card(
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(24),
              children: [
                const Divider(
                  height: 2,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _discountController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      labelText: 'Enter Discount',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field must not be empty';
                      }
                      if (num.parse(value) < 0) {
                        return 'Discount should not be negative';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _vatController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      labelText: 'Enter Vat',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field must not be empty';
                      }
                      if (num.parse(value) < 0) {
                        return 'Vat should not be a negative value';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _deliveryCharge,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      labelText: 'Enter Delivery Charge',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field must not be empty';
                      }
                      if (num.parse(value) < 0) {
                        return 'Delivery Charge should not be negative';
                      }
                      return null;
                    },
                  ),
                ),
                OutlinedButton(
                  onPressed: _Save,
                  child: const Text('Update'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _Save() {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show();
      num discount = num.parse(_discountController.text);
      num vat = num.parse(_vatController.text);
      num deliveryCharge = num.parse(_deliveryCharge.text);

      final model = OrderConstantModel(
        discount: discount,
        vat: vat,
        deliveryCharge: deliveryCharge,
      );

      orderProvider.updateOrderConstants(model).then((value) {
        EasyLoading.dismiss();
        showMsg(context, "Succesful");
      }).catchError((e) {
        EasyLoading.dismiss();
        showMsg(context, "Error");
      });
    }
  }
}
