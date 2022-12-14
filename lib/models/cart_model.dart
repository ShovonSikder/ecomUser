const String collectionCart = 'Cart';

const String cartFieldProductId = 'productId';
const String cartFieldProductName = 'productName';
const String cartFieldProductImageUrl = 'productImageUrl';
const String cartFieldQuantity = 'quantity';
const String cartFieldSalePrice = 'salePrice';
const String cartFieldCategoryId = 'categoryId';
const String cartFieldProductStock = 'productStock';

class CartModel {
  String productId;
  String productName;
  String productImageUrl;
  num productStock;
  num quantity;
  num salePrice;
  String categoryId;

  CartModel({
    required this.productId,
    required this.productName,
    required this.productImageUrl,
    this.quantity = 1,
    required this.salePrice,
    required this.categoryId,
    required this.productStock,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      cartFieldProductId: productId,
      cartFieldProductName: productName,
      cartFieldProductImageUrl: productImageUrl,
      cartFieldQuantity: quantity,
      cartFieldSalePrice: salePrice,
      cartFieldCategoryId: categoryId,
      cartFieldProductStock: productStock,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) => CartModel(
        productId: map[cartFieldProductId],
        productName: map[cartFieldProductName],
        productImageUrl: map[cartFieldProductImageUrl],
        productStock: map[cartFieldProductStock],
        quantity: map[cartFieldQuantity],
        salePrice: map[cartFieldSalePrice],
        categoryId: map[cartFieldCategoryId],
      );
}
