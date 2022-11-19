import 'dart:io';

import 'package:ecomuser/db/db_helper.dart';
import 'package:ecomuser/models/category_model.dart';
import 'package:ecomuser/models/comment_model.dart';
import 'package:ecomuser/models/purchase_model.dart';
import 'package:ecomuser/models/rating_model.dart';
import 'package:ecomuser/models/user_model.dart';
import 'package:ecomuser/utils/helper_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  List<CategoryModel> categoryList = [];
  List<ProductModel> productList = [];

  Future<void> addNewCategory(String category) {
    final categoryModel = CategoryModel(categoryName: category);
    return DbHelper.addCategory(categoryModel);
  }

  getAllCategories() {
    DbHelper.getAllCategories().listen((snapshot) {
      categoryList = List.generate(snapshot.docs.length,
          (index) => CategoryModel.fromMap(snapshot.docs[index].data()));
      categoryList
          .sort((cat1, cat2) => cat1.categoryName.compareTo(cat2.categoryName));
      notifyListeners();
    });
  }

  List<CategoryModel> getCategoryListForFiltering() {
    return [CategoryModel(categoryName: 'All'), ...categoryList];
  }

  getAllProducts() {
    DbHelper.getAllProducts().listen((snapshot) {
      productList = List.generate(snapshot.docs.length,
          (index) => ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  getAllProductsByCategory(CategoryModel categoryModel) {
    DbHelper.getAllProductsByCategory(categoryModel).listen((snapshot) {
      productList = List.generate(snapshot.docs.length,
          (index) => ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  Future<void> repurchase(
      PurchaseModel purchaseModel, ProductModel productModel) {
    return DbHelper.repurchase(purchaseModel, productModel);
  }

  Future<List<PurchaseModel>> getAllPurchaseByProductId(
      String productId) async {
    final snapshot = await DbHelper.getAllPurchaseByProductId(productId);
    return List.generate(snapshot.docs.length,
        (index) => PurchaseModel.fromMap(snapshot.docs[index].data()));
  }

  Future<String> uploadImage(String thumbnailImageLocalPath) async {
    final photoRef = FirebaseStorage.instance
        .ref()
        .child('ProductImages/${DateTime.now().millisecondsSinceEpoch}');
    final uploadTask = photoRef.putFile(File(thumbnailImageLocalPath));
    final snapshot = await uploadTask.whenComplete(() => null);
    return snapshot.ref.getDownloadURL();
  }

  Future<void> addNewProduct(
      ProductModel productModel, PurchaseModel purchaseModel) {
    return DbHelper.addNewProduct(productModel, purchaseModel);
  }

  Future<void> deleteImage(String downloadUrl) {
    return FirebaseStorage.instance.refFromURL(downloadUrl).delete();
  }

  void getOrderConstants() {}

  Future<void> addRating(
      String productId, double userRating, UserModel userModel) async {
    final ratingModel = RatingModel(
      ratingId: userModel.userId,
      userModel: userModel,
      productId: productId,
      rating: userRating,
    );

    await DbHelper.addRating(ratingModel);

    final snapshot = await DbHelper.getRattingsByProduct(ratingModel.productId);
    final ratingList = List.generate(snapshot.docs.length,
        (index) => RatingModel.fromMap(snapshot.docs[index].data()));

    double totalRatings = 0.0;

    for (var model in ratingList) {
      totalRatings += model.rating;
    }

    return DbHelper.updateProductField(
        productId, {productFieldAvgRating: totalRatings / ratingList.length});
  }

  Future<void> addComment(
      String productId, String comment, UserModel userModel) {
    final commentModel = CommentModel(
        approved: true,
        commentId: DateTime.now().microsecondsSinceEpoch.toString(),
        userModel: userModel,
        productId: productId,
        comment: comment,
        date:
            getFormattedDate(DateTime.now(), pattern: 'dd/MM/yyyy hh:mm:s a'));

    return DbHelper.addComment(commentModel);
  }

  Future<List<CommentModel>> getAllCommentByProduct(String productId) async {
    final snapshot = await DbHelper.getAllCommentsByProduct(productId);
    return List.generate(
      snapshot.docs.length,
      (index) => CommentModel.fromMap(
        snapshot.docs[index].data(),
      ),
    );
  }
}
