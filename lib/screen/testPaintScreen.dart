


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:productapp/screen/testCustomPainter.dart';

import '../controller/testWeatherController.dart';

class Testpaintscreen extends StatelessWidget {
      Testpaintscreen({super.key});
      @override
      Widget build(BuildContext context) {
          return Scaffold(
            appBar: AppBar(title: const Text("Custom paint")),
            body: SafeArea(child:GetBuilder<TestWeatherController>(
              init: TestWeatherController(),
              builder: (controller){
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(padding: const EdgeInsets.symmetric(horizontal: 24.0),child:
                    ConstrainedBox(constraints: BoxConstraints(
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
                                  'Test weather',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
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
                            width: 360,
                            height: 300,
                            child: Padding(padding: const EdgeInsets.all(16.0),
                            child: CustomPaint(
                              painter: TestPainter(
                                temperatures: controller.finalForecast.map((data)=> data['temp'] as double).toList(),
                                labels: controller.finalForecast.map((data)=> data['label'] as String).toList(),
                              ),
                            ),),

                          ),
                        )
                      ],
                    ),
                    ),),
                );
              },
            )
            ),
          );
  }
}