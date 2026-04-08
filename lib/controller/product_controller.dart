

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:productapp/service/product_service.dart';

class ProductController extends GetxController{

  final ProductService  _service = ProductService();

  var productList = <dynamic>[].obs;
  var isLoading = true.obs;
  var errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchProduct();
  }

  void fetchProduct() async {
    try {
      isLoading(true);
      errorMessage.value = null;
      var products = await _service.fetchProduct();
      print('PRODUCTS $products');
      productList.assignAll((products));
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading(false);
    }
  }
}

class PopUpController extends GetxController{
  final poppedIndex = RxnInt();
  final longPressIndex = RxnInt();
  final isCityTapped = false.obs;

  void TapCity(){
    if(isCityTapped.value) return;
    isCityTapped.value = true;
    Future.delayed(const Duration(seconds: 1), () {
      isCityTapped.value = false;
    });
  }

  void PopUp(int index) {
    if (poppedIndex.value != null) return;
    HapticFeedback.vibrate();
    poppedIndex.value = index;
    Future.delayed(const Duration(seconds: 1), () {
      poppedIndex.value = null;
    });
  }

  void onLongPressStart(int index) {
    if(longPressIndex.value != null) return;
    HapticFeedback.heavyImpact();
    longPressIndex.value = index;
    Future.delayed(const Duration(seconds: 2), () {
      longPressIndex.value = null;
    });
  }

  void onLongPressEnd() {
    longPressIndex.value = null;
  }

}