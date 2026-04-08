import 'dart:convert';

import 'package:http/http.dart' as http;

class ProductService {
  final baseURl = "https://dummyjson.com/products";

  Future<List<dynamic>> fetchProduct() async {
    try {
      final response = await http.get(Uri.parse(baseURl));
      if (response.statusCode == 200) {
        print('PRODUCT DATA ${response.body}');
        Map<String, dynamic> json = jsonDecode(response.body);
        List<dynamic> data = json['products'];
        return data;
      } else {
        throw Exception(
          "Failed to fetch products: Status ${response.statusCode}",
        );
      }
    } catch (err) {
      print('Error fetching products: $err');
      throw Exception("Error fetching products: $err");
    }
  }
}
