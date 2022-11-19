import 'package:ecomuser/models/address_model.dart';
import 'package:ecomuser/models/cart_model.dart';
import 'package:ecomuser/models/date_model.dart';

class OrderModel {
  String orderId;
  String userId;
  String orderStatus;
  String paymentMethod;
  num grandTotal;
  num discount;
  num VAT;

  DateModel orderDate;
  AddressModel deliveryAddress;
  List<CartModel> productDetails;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.orderStatus,
    required this.paymentMethod,
    required this.grandTotal,
    required this.discount,
    required this.VAT,
    required this.orderDate,
    required this.deliveryAddress,
    required this.productDetails,
  });
}
