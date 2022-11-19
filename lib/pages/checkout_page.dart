import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomuser/models/address_model.dart';
import 'package:ecomuser/models/date_model.dart';
import 'package:ecomuser/models/order_model.dart';
import 'package:ecomuser/providers/cart_provider.dart';
import 'package:ecomuser/providers/order_provider.dart';
import 'package:ecomuser/providers/user_provider.dart';
import 'package:ecomuser/utils/constants.dart';
import 'package:ecomuser/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  static const String routeName = '/checkout';
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late OrderProvider orderProvider;
  late CartProvider cartProvider;
  late UserProvider userProvider;

  String paymentMethodGroupValue = PaymentMethod.cod;
  String? city;

  final addressLine1Controller = TextEditingController();
  final addressLine2Controller = TextEditingController();
  final zipController = TextEditingController();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    orderProvider = Provider.of<OrderProvider>(context, listen: true);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    cartProvider = Provider.of<CartProvider>(context, listen: false);
    _setAddressMethod();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          buildHeaderSection('Product Info'),
          buildProductInfoSection(),
          buildHeaderSection('Order Summary'),
          buildOrderSummarySection(),
          buildHeaderSection('Delivery Address'),
          buildDeliveryAddressSection(),
          buildHeaderSection('Payment Method'),
          buildPaymentMethodSection(),
        ],
      ),
      bottomNavigationBar: Card(
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: BorderSide.none,
        ),
        margin: EdgeInsets.only(bottom: 0),
        color: Theme.of(context).primaryColor,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.transparent,
          ),
          onPressed: _saveOrder,
          child: const Text('Place Order'),
        ),
      ),
    );
  }

  Widget buildHeaderSection(String title) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget buildProductInfoSection() => Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: cartProvider.cartList
                .map((cartModel) => ListTile(
                      title: Text(cartModel.productName),
                      trailing: Text(
                          '${cartModel.quantity} X $currencySymbol${cartModel.salePrice}'),
                    ))
                .toList(),
          ),
        ),
      );

  void _saveOrder() {
    if (addressLine1Controller.text.isEmpty ||
        addressLine2Controller.text.isEmpty ||
        zipController.text.isEmpty ||
        city == null) {
      showMsg(context, 'Please provide a valid address. (all field required)');
      return;
    }
    EasyLoading.show(status: 'Placing order...');
    final orderModel = OrderModel(
      orderId: generateOrderId,
      userId: userProvider.userModel!.userId,
      orderStatus: OrderStatus.pending,
      paymentMethod: paymentMethodGroupValue,
      grandTotal: orderProvider.getGrandTotal(cartProvider.getCartSubTotal()),
      discount: orderProvider.getDiscountAmount(cartProvider.getCartSubTotal()),
      VAT: orderProvider.getVatAmount(cartProvider.getCartSubTotal()),
      deliveryCharge: orderProvider.orderConstantModel.deliveryCharge,
      orderDate: DateModel(
        day: DateTime.now().day,
        month: DateTime.now().month,
        year: DateTime.now().year,
        timestamp: Timestamp.fromDate(
          DateTime.now(),
        ),
      ),
      deliveryAddress: AddressModel(
        addressLine1: addressLine1Controller.text,
        addressLine2: addressLine2Controller.text,
        city: city,
        zipcode: zipController.text,
      ),
      productDetails: cartProvider.cartList,
    );
  }

  Widget buildOrderSummarySection() => Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              ListTile(
                title: const Text('Sub-Total'),
                trailing: Text(
                  '$currencySymbol${cartProvider.getCartSubTotal().toString()}',
                ),
              ),
              ListTile(
                title: Text(
                    'Discount (${orderProvider.orderConstantModel.discount}%)'),
                trailing: Text(
                  '-$currencySymbol${orderProvider.getDiscountAmount(cartProvider.getCartSubTotal())}',
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
              ListTile(
                title: Text('VAT (${orderProvider.orderConstantModel.vat}%)'),
                trailing: Text(
                  '+$currencySymbol${orderProvider.getVatAmount(cartProvider.getCartSubTotal())}',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              ListTile(
                title: const Text('Delivery Charge'),
                trailing: Text(
                  '$currencySymbol${orderProvider.orderConstantModel.deliveryCharge}',
                ),
                subtitle: const Text(
                  'Inside Dhaka city',
                  style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
                ),
              ),
              const Divider(
                color: Colors.black,
              ),
              ListTile(
                title: const Text(
                  'Grand Total',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  '$currencySymbol${orderProvider.getGrandTotal(cartProvider.getCartSubTotal())}',
                  style: const TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildDeliveryAddressSection() => Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              TextField(
                controller: addressLine1Controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Address 1',
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              TextField(
                controller: addressLine2Controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Address 2',
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.datetime,
                      controller: zipController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Zip Code',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    child: DropdownButton<String>(
                      underline: const Text(''),
                      elevation: 0,
                      value: city,
                      hint: const Text('Select your city'),
                      isExpanded: false,
                      onChanged: (value) {
                        setState(() {
                          city = value;
                        });
                      },
                      items: cities
                          .map(
                            (city) => DropdownMenuItem<String>(
                              value: city,
                              child: Text(city),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget buildPaymentMethodSection() => Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Radio(
                value: PaymentMethod.cod,
                groupValue: paymentMethodGroupValue,
                onChanged: (value) {
                  setState(() {
                    paymentMethodGroupValue = value!;
                  });
                },
              ),
              const Text(PaymentMethod.cod),
              Radio(
                value: PaymentMethod.online,
                groupValue: paymentMethodGroupValue,
                onChanged: (value) {
                  setState(() {
                    paymentMethodGroupValue = value!;
                  });
                },
              ),
              const Text(PaymentMethod.online),
            ],
          ),
        ),
      );

  @override
  void dispose() {
    // TODO: implement dispose
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    zipController.dispose();
    super.dispose();
  }

  void _setAddressMethod() {
    if (userProvider.userModel != null) {
      if (userProvider.userModel!.addressModel != null) {
        final address = userProvider.userModel!.addressModel!;
        addressLine1Controller.text = address.addressLine1!;
        addressLine2Controller.text = address.addressLine2!;
        zipController.text = address.zipcode!;
        city = address.city;
      }
    }
  }
}
