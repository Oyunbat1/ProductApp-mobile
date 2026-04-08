import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:productapp/controller/weather_controller.dart';
import 'package:productapp/screen/customPainter.dart';

class Paintscreen extends StatelessWidget {
  Paintscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Custom paint")),
      body: SafeArea(
        child: GetBuilder<WeatherController>(
          init: WeatherController(),
          builder: (controller) {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            final weather = controller.weather.value!;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Container(
                        child: Column(
                          children: [
                            Center(
                              child: const Text(
                                'Weather',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Center(
                              child: Text(
                                weather['cityName'] ?? 'Unknown',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 300,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CustomPaint(
                              painter: WeatherPainter(
                                temperatures: controller.processedForecast
                                    .map((data) => data['temp'] as double)
                                    .toList(),
                                labels: controller.processedForecast
                                    .map((data) => data['label'] as String)
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
