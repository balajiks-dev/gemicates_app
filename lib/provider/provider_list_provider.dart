import 'package:flutter/material.dart';
import 'package:gemicates_flutter_app/model/product_list_model.dart';
import 'package:gemicates_flutter_app/services/product_service.dart';

class ProductListProvider extends ChangeNotifier {
  bool isLoading = false;
  List<Product> _productList = [];
  List<Product> get productList => _productList;

  Future<void> getAllProducts() async {
    isLoading = true;
    final response = await  TodoService().getProducts();
    _productList = response;
    isLoading = false;
    notifyListeners();
  }
}