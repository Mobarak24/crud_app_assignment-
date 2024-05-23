import 'dart:convert';
import 'package:crud_app/model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class UpdateProductScreen extends StatefulWidget {
  const UpdateProductScreen({super.key, required this.productModel});
  final ProductModel productModel;

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _productCodeTEController = TextEditingController();
  final TextEditingController _unitPriceTEController = TextEditingController();
  final TextEditingController _quantityTEController = TextEditingController();
  final TextEditingController _totalPriceTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _productUpdateInProgress = false;

  @override
  void initState() {
    _nameTEController.text = widget.productModel.productName ?? "";
    _productCodeTEController.text = widget.productModel.productCode ?? "";
    _unitPriceTEController.text = widget.productModel.unitPrice ?? "";
    _quantityTEController.text = widget.productModel.quantity ?? "";
    _totalPriceTEController.text = widget.productModel.totalPrice ?? "";
    _imageTEController.text = widget.productModel.image ?? "";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Update Product'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameTEController,
                decoration:
                    const InputDecoration(hintText: 'Name', labelText: 'Name'),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Write your Name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _productCodeTEController,
                decoration: const InputDecoration(
                    hintText: 'Product Code', labelText: 'Product Code'),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Write your Product Code";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _unitPriceTEController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: 'Unit Price', labelText: 'Unit Price'),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Write your Unit price";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _quantityTEController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: 'Quantity', labelText: 'Quantity'),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Write your Quantity";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _totalPriceTEController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: 'Total Price', labelText: 'Total Price'),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Write your Total Price";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _imageTEController,
                decoration: const InputDecoration(
                    hintText: 'Image', labelText: 'Image'),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Write your Image";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: _productUpdateInProgress == false,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _updateProduct();
                      }
                    },
                    child: const Text('Update')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateProduct() async {
    _productUpdateInProgress = true;
    setState(() {});

    Map<String, dynamic> inputData = {
      "Img": _imageTEController.text,
      "ProductCode": _productCodeTEController.text,
      "ProductName": _nameTEController.text,
      "Qty": _quantityTEController.text,
      "TotalPrice": _totalPriceTEController.text,
      "UnitPrice": _unitPriceTEController.text
    };

    String updateProductUrl =
        "https://crud.teamrabbil.com/api/v1/UpdateProduct/${widget.productModel.id}";
    Uri uri = Uri.parse(updateProductUrl);
    Response response = await post(uri,
        headers: {"content-type": "application/json"},
        body: jsonEncode(inputData));

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product has been Updated')));
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed! Try Again')));
    }
  }
}
