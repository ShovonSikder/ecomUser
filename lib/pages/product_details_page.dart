import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecomuser/auth/authservice.dart';
import 'package:ecomuser/customwidgets/image_holder_view.dart';
import 'package:ecomuser/models/comment_model.dart';
import 'package:ecomuser/models/product_model.dart';
import 'package:ecomuser/pages/login_page.dart';
import 'package:ecomuser/providers/cart_provider.dart';
import 'package:ecomuser/providers/product_provider.dart';
import 'package:ecomuser/providers/user_provider.dart';
import 'package:ecomuser/utils/constants.dart';
import 'package:ecomuser/utils/helper_functions.dart';
import 'package:ecomuser/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ProductDetailsPage extends StatefulWidget {
  static const String routeName = '/product_details';
  ProductDetailsPage({Key? key}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late ProductModel productModel;
  late Size size;

  double userRating = 0.0;
  late ProductProvider productProvider;
  final txtController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    size = MediaQuery.of(context).size;
    productModel = ModalRoute.of(context)!.settings.arguments as ProductModel;
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    txtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productModel.productName),
      ),
      body: ListView(
        children: [
          CachedNetworkImage(
            imageUrl: productModel.thumbnailImageUrl,
            height: 400,
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(
              Icons.error,
              color: Colors.red,
            ),
          ),
          Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageHolderView(
                  url: productModel.additionalImages[0],
                  onImagePressed: (url) {
                    showImageOnDialogue(url);
                  },
                  child: const Icon(Icons.photo),
                ),
                ImageHolderView(
                    url: productModel.additionalImages[1],
                    onImagePressed: (url) {
                      showImageOnDialogue(url);
                    },
                    child: const Icon(Icons.photo)),
                ImageHolderView(
                    url: productModel.additionalImages[2],
                    onImagePressed: (url) {
                      showImageOnDialogue(url);
                    },
                    child: const Icon(Icons.photo)),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    if (AuthService.currentUser!.isAnonymous) {
                      redirectingDialog(
                        context: context,
                        source: ProductDetailsPage.routeName,
                        destination: LoginPage.routeName,
                        title: 'Login Required to Rate',
                        msg: 'Goto Login page to sign up or sign in',
                      );
                      return;
                    }
                  },
                  icon: const Icon(Icons.favorite),
                  label: const Text(
                    'ADD TO FAVORITE',
                  ),
                ),
              ),
              Expanded(
                child:
                    Consumer<CartProvider>(builder: (context, provider, child) {
                  final isInCart =
                      provider.isProductInCart(productModel.productId!);
                  return OutlinedButton.icon(
                    onPressed: productModel.stock == 0
                        ? null
                        : () {
                            if (AuthService.currentUser!.isAnonymous) {
                              redirectingDialog(
                                context: context,
                                source: ProductDetailsPage.routeName,
                                destination: LoginPage.routeName,
                                title: 'Login Required to Rate',
                                msg: 'Goto Login page to sign up or sign in',
                              );
                              return;
                            }
                            isInCart
                                ? provider
                                    .removeFromCart(productModel.productId!)
                                : provider.addToCart(productModel);
                          },
                    icon: Icon(isInCart
                        ? Icons.remove_shopping_cart
                        : Icons.shopping_cart),
                    label: Text(
                      productModel.stock == 0
                          ? 'Out of Stock'
                          : isInCart
                              ? 'REMOVE FROM CART'
                              : 'ADD TO CART',
                    ),
                  );
                }),
              ),
            ],
          ),
          ListTile(
            title: Text(productModel.productName),
            subtitle: Text(productModel.category.categoryName),
          ),
          ListTile(
            title: Text(
                'Sale Price: $currencySymbol${calculatePriceAfterDiscount(productModel.salePrice, productModel.productDiscount)}'),
            subtitle: Text('Stock: ${productModel.stock}'),
          ),
          ListTile(
            title: const Text('Available'),
            trailing: Text(productModel.available ? 'YES' : 'NO'),
          ),
          ListTile(
            title: const Text('Featured'),
            trailing: Text(productModel.featured ? 'YES' : 'NO'),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  const Text(
                    'Rate this product',
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: RatingBar.builder(
                      initialRating: productModel.avgRating.toDouble(),
                      minRating: 0.0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      ignoreGestures: false,
                      itemSize: 30,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        userRating = rating;
                      },
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      if (AuthService.currentUser!.isAnonymous) {
                        redirectingDialog(
                          context: context,
                          source: ProductDetailsPage.routeName,
                          destination: LoginPage.routeName,
                          title: 'Login Required to Rate',
                          msg: 'Goto Login page to sign up or sign in',
                        );
                        return;
                      }
                      try {
                        EasyLoading.show(status: 'Saving');
                        await productProvider.addRating(
                            productModel.productId!,
                            userRating,
                            context.read<UserProvider>().userModel!);
                        EasyLoading.dismiss();
                        if (mounted) {
                          showMsg(context, 'Thanks for your ratings');
                        }
                      } catch (err) {
                        EasyLoading.dismiss();
                        showMsg(context, 'Saving failed');
                        rethrow;
                      }
                    },
                    child: const Text(
                      'Submit',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  const Text(
                    'Add Your Comment',
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: txtController,
                      focusNode: focusNode,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      if (txtController.text.isEmpty) {
                        showMsg(context, 'Comment can\'t be empty');
                        return;
                      }
                      if (AuthService.currentUser!.isAnonymous) {
                        redirectingDialog(
                          context: context,
                          source: ProductDetailsPage.routeName,
                          destination: LoginPage.routeName,
                          title: 'Login Required to Comment',
                          msg: 'Goto Login page to sign up or sign in',
                        );
                        return;
                      }
                      try {
                        EasyLoading.show(status: 'Saving');
                        await productProvider.addComment(
                            productModel.productId!,
                            txtController.text,
                            context.read<UserProvider>().userModel!);
                        focusNode.unfocus();
                        EasyLoading.dismiss();

                        if (mounted) {
                          showMsg(context,
                              'Thanks for your comment. Your comments are waiting to approved by admin');
                        }
                      } catch (err) {
                        EasyLoading.dismiss();
                        showMsg(context, 'Saving failed');
                        rethrow;
                      }
                    },
                    child: const Text(
                      'Submit',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text('All Comments'),
          ),
          FutureBuilder<List<CommentModel>>(
            future:
                productProvider.getAllCommentByProduct(productModel.productId!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final commentList = snapshot.data!;
                if (commentList.isEmpty) {
                  return const Center(child: Text('No comments found'));
                }

                return Column(
                  children: commentList
                      .map((model) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.person),
                                title: Text(model.userModel.displayName ??
                                    model.userModel.email),
                                subtitle: Text(model.date),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 8),
                                child: Text(model.comment),
                              ),
                            ],
                          ))
                      .toList(),
                );
              }
              if (snapshot.hasError) {
                return const Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 20,
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )
        ],
      ),
    );
  }

  void showImageOnDialogue(String url) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          content: CachedNetworkImage(
            imageUrl: url,
            height: 400,
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(
              Icons.error,
              color: Colors.red,
            ),
          ),
        );
      },
    );
  }
}
