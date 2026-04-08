import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:productapp/controller/product_controller.dart';
import 'package:productapp/controller/weather_controller.dart';
import 'package:productapp/screen/testCustomPainter.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WeatherScreen extends StatelessWidget {
  final PopUpController _popUpController = Get.put(PopUpController());

  WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFF8832), Color(0xFFFF8812), Color(0xFFFF8812)],
          ),
        ),
        constraints: BoxConstraints(
          minHeight: double.infinity,
          minWidth: double.infinity,
        ),
        child: SafeArea(
          child: GetBuilder<WeatherController>(
            init: WeatherController(),
            builder: (controller) {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.black),
                );
              }

              final weather = controller.weather.value!;
              final forecast = controller.processedForecast;

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Obx(() {
                    final tapped = _popUpController.isCityTapped.value;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const SizedBox(height: 20),

                        Center(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () => _popUpController.TapCity(),
                                child: AnimatedDefaultTextStyle(
                                  style: TextStyle(
                                    fontSize: tapped ? 32 : 24,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                    letterSpacing: 2,
                                  ),
                                  duration: Duration(milliseconds: 300),
                                  child: Text(weather['cityName'] ?? 'Unknown'),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TweenAnimationBuilder(
                                tween: Tween(
                                  begin: 0,
                                  end: (weather['temp'] as num).toDouble(),
                                ),
                                duration: const Duration(milliseconds: 1500),
                                curve: Curves.easeOut,
                                builder: (context, value, child) {
                                  return Text(
                                    '${value.toInt()}°',
                                    style: const TextStyle(
                                      fontSize: 90,
                                      fontWeight: FontWeight.w100,
                                      color: Colors.black,
                                      height: 1.0,
                                    ),
                                  );
                                },
                              ),
                              Text(
                                weather['description'] ?? 'Clear sky',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        const SizedBox(height: 20),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.15),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '5 ХОНОГИЙН УРЬДЧИЛСАН МЭДЭЭ',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                height: 200,
                                child: TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 0.0, end: 1.0),
                                  duration: Duration(milliseconds: 1500),
                                  builder: (context, value, child) {
                                    return CustomPaint(
                                      painter: TestPainter(
                                        temperatures: forecast
                                            .map((d) => d['temp'] as double)
                                            .toList(),
                                        labels: forecast
                                            .map((d) => d['label'] as String)
                                            .toList(),
                                        animationValue: value,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                        ),

                        const SizedBox(height: 32),
                      ],
                    );
                  }),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Widget _statCard(String label, String value, IconData icon) {
  //   return Expanded(
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
  //       decoration: BoxDecoration(
  //         color: Colors.white.withOpacity(0.1),
  //         borderRadius: BorderRadius.circular(20),
  //         border: Border.all(
  //           color: Colors.white,
  //           width: 1,
  //         ),
  //       ),
  //       child: Column(
  //         children: [
  //           Icon(icon, color: Colors.white70, size: 20),
  //           const SizedBox(height: 8),
  //           Text(
  //             value,
  //             style: const TextStyle(
  //               fontSize: 18,
  //               fontWeight: FontWeight.w600,
  //               color: Colors.white,
  //             ),
  //           ),
  //           const SizedBox(height: 4),
  //           Text(
  //             label,
  //             style: const TextStyle(
  //               fontSize: 11,
  //               color: Colors.white54,
  //             ),
  //             textAlign: TextAlign.center,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
