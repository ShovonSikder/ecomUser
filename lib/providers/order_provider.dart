import 'package:ecomuser/db/db_helper.dart';
import 'package:ecomuser/models/order_constant_model.dart';
import 'package:flutter/widgets.dart';

class OrderProvider extends ChangeNotifier {
  OrderConstantModel orderConstantModel = OrderConstantModel();

  getOrderConstants() {
    DbHelper.getOrderSnapshots().listen((snapshot) {
      if (snapshot.exists) {
        orderConstantModel = OrderConstantModel.fromMap(snapshot.data()!);
        notifyListeners();
      }
    });
  }

  Future<void> updateOrderConstants(OrderConstantModel model) {
    return DbHelper.updateOrderConstants(model);
  }

  int getDiscountAmount(num cartSubTotal) =>
      ((cartSubTotal * orderConstantModel.discount) / 100).round();

  int getVatAmount(num cartSubTotal) =>
      (((cartSubTotal - getDiscountAmount(cartSubTotal)) *
                  orderConstantModel.vat) /
              100)
          .round();

  int getGrandTotal(num cartSubTotal) => (cartSubTotal -
          getDiscountAmount(cartSubTotal) +
          getVatAmount(cartSubTotal) +
          orderConstantModel.deliveryCharge)
      .round();
}
