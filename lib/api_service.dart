import 'package:f_http_a3/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String baseUrl = "https://fakestoreapi.com";

class ApiService {
  Future<List<Product>> getAllProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));
      final decode = json.decode(response.body) as List;
      return decode.map((e) => Product.fromJson(e)).toList();
    } catch(e) {
      print(e.toString());
      return [];
    }
  }
  Future<bool> deleteProduct(int? id) async {
    final response = await http.delete(Uri.parse('$baseUrl/products/$id'));
    return response.statusCode == 200;
  }
  Future<bool> createProduct(Product product) async{
    final response = await http.post(Uri.parse('$baseUrl/product'),body: product.toJson());
    return response.statusCode == 201;
  }
  Future<bool> updateProduct(int? id, Product product) async {
    final response = await http.put(Uri.parse('$baseUrl/product/$id'),body: product.toJson());
    return response.statusCode == 200;
  }
}