import 'dart:convert';
import 'package:gemicates_flutter_app/model/product_list_model.dart';
import 'package:http/http.dart' as http;

class TodoService {

  Future<List<Product>> getProducts() async {
    const url = 'https://dummyjson.com/products';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    List<Product> productList = [];
    if (response.statusCode == 200) {
      (jsonDecode(response.body)["products"]).forEach((f) => productList.add(Product.fromJson(f)));
      return productList;
    }
    return productList;
  }
}