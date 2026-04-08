  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';
  import 'package:get/get_core/src/get_main.dart';
  import 'package:get/get_instance/src/extension_instance.dart';
  import 'package:get/get_navigation/src/extension_navigation.dart';
  import 'package:productapp/controller/product_controller.dart';
  import 'package:get/get.dart';
  import 'package:productapp/controller/weather_controller.dart';
  import 'package:productapp/screen/paintScreen.dart';
  import 'package:productapp/screen/testPaintScreen.dart';
  import 'package:productapp/screen/weatherScreen.dart';
  import '../service/auth_service.dart';
  import 'login.dart';
  
  class HomeScreen extends StatelessWidget {
    final ProductController _productController = Get.put(ProductController());
    final PopUpController _popUpController = Get.put(PopUpController());
    final RxInt selectedIndex = RxInt(-1);
  
    @override
    Widget build(BuildContext context) {
      final user = FirebaseAuth.instance.currentUser;
      final weatherController = Get.put(WeatherController());
      return Scaffold(
        appBar: AppBar(
          actions: [
            Obx(() {
              if (weatherController.weather.value == null) {
                return IconButton(
                  onPressed: () => Get.to(() => WeatherScreen()),
                  icon: const Icon(Icons.cloud_off, color: Colors.white),
                );
              }
              final weather = weatherController.weather.value!;
              return GestureDetector(
                onTap: () => Get.to(() => WeatherScreen()),
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.network(
                        "https://openweathermap.org/img/wn/${weather['icon']}.png",
                        width: 32,
                        height: 32,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.cloud,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${weather['temp']}°C",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
        drawer: Drawer(
          child: Container(
            child: Column(
              children: [
                UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white24,
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : null,
                    child: user?.photoURL == null
                        ? const Icon(Icons.person, color: Colors.black)
                        : null,
                  ),
                  accountName: Text(
                    user?.displayName ?? 'Customer',
                    style: const TextStyle(color: Colors.black),
                  ),
                  accountEmail: Text(
                    user?.email ?? 'There is no email',
                    style: const TextStyle(color: Colors.black),
                  ),
                  decoration: const BoxDecoration(color: Colors.transparent),
                ),
                ListTile(
                  title: const Text(
                    "CustomPaint",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onTap: () async {
                    Get.to(() => Paintscreen());
                  },
                ),
                ListTile(
                  title: const Text(
                    "TestCustomPaint",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onTap: () async {
                    Get.to(() => Testpaintscreen());
                  },
                ),
                const Spacer(),
                const Divider(color: Colors.white24),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.black),
                  title: const Text(
                    "Log out",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () async {
                    await AuthService().signOut();
                    Get.offAll(() => LoginScreen());
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        body: Center(
          child: Container(
            child: Obx(() {
              if (_productController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (_productController.errorMessage.value != null) {
                return Center(
                  child: Text(_productController.errorMessage.value!),
                );
              }
              if (_productController.productList.isEmpty) {
                return const Center(child: Text('Бараа олдсонгүй'));
              }
              return ReorderableListView.builder(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 40,
                  right: 40,
                  bottom: 20,
                ),
                itemCount: _productController.productList.length,
                onReorder: (oldIndex, newIndex) {
                  if (newIndex > oldIndex) newIndex--;
                  final item = _productController.productList.removeAt(oldIndex);
                  _productController.productList.insert(newIndex, item);
                },
                proxyDecorator: (child, index, animation) {
                  return Material(
                    color: Colors.transparent,
                    child: Transform.scale(
                      scale: 1.05,
                      child: child,
                    ),
                  );
                },
                itemBuilder: (context, index) {
                  final product = _productController.productList[index];

                  return Obx(
                    key: ValueKey(product['id'] ?? index),
                        () {
                      final bool isPopped =
                          _popUpController.poppedIndex.value == index;
                      final bool isLongPressed =
                          _popUpController.longPressIndex.value == index;

                      return GestureDetector(
                        onTap: () {
                          _popUpController.PopUp(index);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOutBack,
                          height: isPopped ? 160 : 130,
                          margin: const EdgeInsets.only(bottom: 15),
                          padding: const EdgeInsets.all(10),
                          transformAlignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF8812),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade200),
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.black.withOpacity(
                            //       isLongPressed ? 0.15 : 0.05,
                            //     ),
                            //     blurRadius: isLongPressed ? 20 : 10,
                            //     offset: isLongPressed
                            //         ? const Offset(0, 10)
                            //         : const Offset(0, 5),
                            //   ),
                            // ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.white,
                                  child: Image.network(
                                    product['thumbnail'],
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AnimatedDefaultTextStyle(
                                      duration: const Duration(milliseconds: 400),
                                      style: TextStyle(
                                        fontSize: isLongPressed ? 18 : 16,
                                        fontWeight: FontWeight.w600,
                                        color: isLongPressed
                                            ? Colors.red
                                            : Colors.black,
                                      ),
                                      child: Text(
                                        product['title'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Text(
                                          "${product['price']} \$",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.drag_handle,
                                color: Colors.black38,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }),
          ),
        ),
      );
    }
  }