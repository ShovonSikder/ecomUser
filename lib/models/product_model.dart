import 'package:ecomuser/models/category_model.dart';

const String collectionProduct = 'products';
const String productFieldId = 'productId';
const String productFieldName = 'productName';
const String productFieldCategory = 'category';
const String productFieldShortDescription = 'shortDescription';
const String productFieldLongDescription = 'longDescription';
const String productFieldSalePrice = 'salePrice';
const String productFieldStock = 'stock';
const String productFieldAvgRating = 'avgRating';
const String productFieldProductDiscount = 'productDiscount';
const String productFieldThumbnailImageUrl = 'thumbnailImageUrl';
const String productFieldAdditionalImages = 'additionalImage';
const String productFieldAvailable = 'available';
const String productFieldFeatured = 'featured';

class ProductModel {
  String? productId;
  String productName;
  CategoryModel category;
  String? shortDescription;
  String? longDescription;
  num salePrice;
  num stock;
  num avgRating;
  num productDiscount;
  String thumbnailImageUrl;
  List<String> additionalImages;
  bool available;
  bool featured;

  ProductModel({
    this.productId,
    required this.productName,
    required this.category,
    this.shortDescription,
    this.longDescription,
    required this.salePrice,
    required this.stock,
    this.avgRating = 0.0,
    this.productDiscount = 0,
    required this.thumbnailImageUrl,
    required this.additionalImages,
    this.available = true,
    this.featured = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      productFieldId: productId,
      productFieldName: productName,
      productFieldCategory: category.toMap(),
      productFieldShortDescription: shortDescription,
      productFieldLongDescription: longDescription,
      productFieldSalePrice: salePrice,
      productFieldStock: stock,
      productFieldAvgRating: avgRating,
      productFieldProductDiscount: productDiscount,
      productFieldThumbnailImageUrl: thumbnailImageUrl,
      productFieldAdditionalImages: additionalImages,
      productFieldAvailable: available,
      productFieldFeatured: featured,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) => ProductModel(
        productId: map[productFieldId],
        productName: map[productFieldName],
        category: CategoryModel.fromMap(map[productFieldCategory]),
        salePrice: map[productFieldSalePrice],
        stock: map[productFieldStock],
        avgRating: map[productFieldAvgRating],
        thumbnailImageUrl: map[productFieldThumbnailImageUrl],
        available: map[productFieldAvailable],
        additionalImages: map[productFieldAdditionalImages] == null
            ? ['', '', '']
            : (map[productFieldAdditionalImages] as List)
                .map((e) => e as String)
                .toList(),
        featured: map[productFieldFeatured],
        longDescription: map[productFieldLongDescription],
        shortDescription: map[productFieldShortDescription],
        productDiscount: map[productFieldProductDiscount],
      );
}
