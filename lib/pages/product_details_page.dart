import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecomuser/customwidgets/image_holder_view.dart';
import 'package:ecomuser/models/product_model.dart';
import 'package:ecomuser/providers/product_provider.dart';
import 'package:flutter/material.dart';
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

  late ProductProvider provider;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    size = MediaQuery.of(context).size;
    productModel = ModalRoute.of(context)!.settings.arguments as ProductModel;
    provider = Provider.of<ProductProvider>(context, listen: false);
    super.didChangeDependencies();
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
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.add,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  url: productModel.additionalImages[0],
                  onImagePressed: (url) {
                    showImageOnDialogue(url);
                  },
                ),
                ImageHolderView(
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.add,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    url: productModel.additionalImages[1],
                    onImagePressed: (url) {
                      showImageOnDialogue(url);
                    }),
                ImageHolderView(
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.add,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    url: productModel.additionalImages[2],
                    onImagePressed: (url) {
                      showImageOnDialogue(url);
                    }),
              ],
            ),
          ),
          ListTile(
            title: Text(productModel.productName),
            subtitle: Text(productModel.category.categoryName),
          ),
          ListTile(
            title: Text('Sale Price: ${productModel.salePrice}\$'),
            subtitle: Text('Stock: ${productModel.stock}'),
          ),
          SwitchListTile(
              title: const Text('Available'),
              value: productModel.available,
              onChanged: (value) {
                setState(() {
                  productModel.available = !productModel.available;
                });
              }),
          SwitchListTile(
              title: const Text('Featured'),
              value: productModel.featured,
              onChanged: (value) {
                setState(() {
                  productModel.featured = !productModel.featured;
                });
              }),
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
          actions: [
            TextButton(onPressed: () {}, child: Text("Change")),
            TextButton(onPressed: () {}, child: Text("Delete")),
          ],
        );
      },
    );
  }
}
