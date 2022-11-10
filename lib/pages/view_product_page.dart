import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecomuser/pages/product_details_page.dart';
import 'package:ecomuser/providers/order_provider.dart';
import 'package:ecomuser/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../customwidgets/main_drawer.dart';
import '../models/category_model.dart';
import '../providers/product_provider.dart';

class ViewProductPage extends StatefulWidget {
  static const String routeName = '/viewproduct';
  const ViewProductPage({Key? key}) : super(key: key);

  @override
  State<ViewProductPage> createState() => _ViewProductPageState();
}

class _ViewProductPageState extends State<ViewProductPage> {
  CategoryModel? categoryModel;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    Provider.of<ProductProvider>(context, listen: false).getAllProducts();
    Provider.of<ProductProvider>(context, listen: false).getAllCategories();
    Provider.of<OrderProvider>(context, listen: false).getOrderConstants();
    Provider.of<UserProvider>(context, listen: false).getUserInfo();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Consumer<ProductProvider>(
                builder: (context, provider, child) =>
                    DropdownButtonFormField<CategoryModel>(
                  hint: const Text('Select Category'),
                  value: categoryModel,
                  isExpanded: true,
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                  items: provider
                      .getCategoryListForFiltering()
                      .map((catModel) => DropdownMenuItem(
                          value: catModel, child: Text(catModel.categoryName)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      categoryModel = value;
                    });
                    provider.getAllProductsByCategory(categoryModel!);
                  },
                ),
              ),
              Expanded(
                child: provider.productList.isEmpty
                    ? const Center(
                        child: Text('No product found'),
                      )
                    : ListView.builder(
                        itemCount: provider.productList.length,
                        itemBuilder: (context, index) {
                          final product = provider.productList[index];
                          return ListTile(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, ProductDetailsPage.routeName,
                                  arguments: provider.productList[index]);
                            },
                            leading: CachedNetworkImage(
                              width: 75,
                              imageUrl: product.thumbnailImageUrl,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            title: Text(product.productName),
                            subtitle: Text(product.category.categoryName),
                            trailing: Text('Stock: ${product.stock}'),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
