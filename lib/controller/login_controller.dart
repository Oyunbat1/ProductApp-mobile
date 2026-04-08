import 'package:get/get.dart';

class LoginController  extends GetxController{
  var isNotVisible = true.obs;

  void togglePassword(){
    isNotVisible.value = !isNotVisible.value;
  }
}