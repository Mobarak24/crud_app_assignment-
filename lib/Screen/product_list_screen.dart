import 'dart:convert';
import 'dart:core';
import 'package:crud_app/Screen/add_product_screen.dart';
import 'package:crud_app/Model/model.dart';
import 'package:crud_app/Screen/update_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool _productListInProgress = false;
  final List<ProductModel> productList = [];

  @override
  void initState() {
    _getProductList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: RefreshIndicator(
        onRefresh: _getProductList,
        child: Visibility(
          visible: _productListInProgress == false,
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
          child: ListView.separated(
            itemCount: productList.length,
            itemBuilder: (context, index) {
              return _buildProductItem(productList[index]);
            },
            separatorBuilder: (context, index) => const Divider(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddProductScreen()));
          if(result == true){
            _getProductList();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _getProductList() async {
    _productListInProgress = true;
    setState(() {});
    productList.clear();
    const String productListUrl =
        "https://crud.teamrabbil.com/api/v1/ReadProduct";
    Uri uri = Uri.parse(productListUrl);
    Response response = await get(uri);
    _productListInProgress = false;
    setState(() {});
    if (response.statusCode == 200) {
      final dataDecode = jsonDecode(response.body);
      final jsonProductList = dataDecode['data'];
      for (var json in jsonProductList) {
        ProductModel productModel = ProductModel.fromJson(json);
        productList.add(productModel);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed! Try Again'),
        ),
      );
    }
  }

  Widget _buildProductItem(ProductModel product) {
    return ListTile(
      leading: SizedBox(
        height: 60,
        width: 60,
        child: Image.network(product.image ?? ""),
      ),
      title: Text(product.productName ?? "Unknown"),
      subtitle: Wrap(
        children: [
          Text('Unit Price : ${product.unitPrice} '),
          Text('Quantity : ${product.quantity} '),
          Text('Total Price : ${product.totalPrice}'),
        ],
      ),
      trailing: Wrap(
        children: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UpdateProductScreen(
                            productModel: product,
                          )));
              if (result == true) {
                _getProductList();
              }
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              _showConfirmationDialog(product.id!);
            },
            icon: const Icon(Icons.delete_rounded),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(String productId) {
    showDialog(context: context, builder: (context){
          return AlertDialog(
            title: const Text("Delete !"),
            content:
                const Text('Are you sure that want to delete this product'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _deleteProduct(productId);
                },
                child: const Text('yes,Delete!'),
              ),
            ],
          );
        });
  }

  Future<void> _deleteProduct(String productId) async {
    String deleteProductUrl =
        "https://crud.teamrabbil.com/api/v1/DeleteProduct/$productId";
    Uri uri = Uri.parse(deleteProductUrl);
    Response response = await get(uri);

    if (response.statusCode == 200) {
      _getProductList();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Successfully Deleted"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Fail!Try Again"),
        ),
      );
    }
  }
}
