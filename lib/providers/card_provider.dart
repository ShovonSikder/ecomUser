import 'package:ecomuser/auth/authservice.dart';
import 'package:ecomuser/db/db_helper.dart';
import 'package:ecomuser/models/cart_model.dart';
import 'package:ecomuser/models/product_model.dart';
import 'package:ecomuser/utils/helper_functions.dart';
import 'package:flutter/foundation.dart';

class CartProvider extends ChangeNotifier {
  List<CartModel> cartList = [];

  num priceWithQuantity(CartModel cartModel) =>
      cartModel.salePrice * cartModel.quantity;

  int get totalItemsInCart => cartList.length;

  bool isProductInCart(String pid) {
    for (final cartModel in cartList) {
      if (cartModel.productId == pid) {
        return true;
      }
    }
    return false;
  }

  Future<void> addToCart(ProductModel productModel) {
    final cartModel = CartModel(
      productId: productModel.productId!,
      productName: productModel.productName,
      productImageUrl: productModel.thumbnailImageUrl,
      salePrice: num.parse(calculatePriceAfterDiscount(
          productModel.salePrice, productModel.productDiscount)),
      categoryId: productModel.category.categoryId!,
    );
    return DbHelper.addToCart(AuthService.currentUser!.uid, cartModel);
  }

  Future<void> removeFromCart(String pid) {
    return DbHelper.removeFromCart(AuthService.currentUser!.uid, pid);
  }

  void getAllCartItems() {
    DbHelper.getAllCartItems(AuthService.currentUser!.uid).listen((snapshot) {
      cartList = List.generate(snapshot.docs.length,
          (index) => CartModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  void increaseQuantity(CartModel cartModel) {
    cartModel.quantity += 1;
    DbHelper.updateCartQuantity(AuthService.currentUser!.uid, cartModel);
  }

  void decreaseQuantity(CartModel cartModel) {
    if (cartModel.quantity > 1) {
      cartModel.quantity -= 1;
      DbHelper.updateCartQuantity(AuthService.currentUser!.uid, cartModel);
    }
  }

  num getCartSubTotal() {
    num total = 0;
    for (final cartModel in cartList) {
      total += priceWithQuantity(cartModel);
    }
    return total;
  }
}
