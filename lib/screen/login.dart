import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:productapp/controller/login_controller.dart';
import 'package:productapp/screen/signup.dart';
import '../service/auth_service.dart';
import 'home.dart';

class LoginScreen extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E2DF),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(25.0),
          margin: const EdgeInsets.only(top: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // color: Colors.amberAccent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Log in",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 34,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "by loggin in , you agree to our Terms of Use.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Container(
                // color: Colors.amberAccent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Your email",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Obx(()=>
                        TextField(
                          controller: passwordController,
                          obscureText: controller.isNotVisible.value,
                          decoration: InputDecoration(
                            labelText: "Your password",
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: IconButton(
                              icon: Icon(controller.isNotVisible.value
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: controller.togglePassword,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        )),
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF8812),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: () async {
                          try {
                            await AuthService().signInWithEmail(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            );
                            Get.offAll(() =>  HomeScreen());
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                        },
                        child: const Text(
                          "Connect",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(() => Signup(),
                              transition: Transition.rightToLeftWithFade,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                            },
                            child: Text(
                              "Sign up",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.black,
                                decorationThickness: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          _socialButton(
                            "Sign in with google",
                            Colors.white,
                                () => AuthService().signInWithGoogle(),
                          ),
                          _socialButton("Sign in with Facebook", Colors.white,
                                  () => AuthService().signInWithFacebook(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 18,),
                    Text("For more infromation , please see ou Privacy policy",style: TextStyle(fontWeight: FontWeight.w300))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _socialButton(String label, Color color, VoidCallback onTap) {

    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: SizedBox(width: double.infinity,
        height: 55,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.black,
            side: const BorderSide(color: Colors.grey),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          onPressed: onTap,
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }
}
