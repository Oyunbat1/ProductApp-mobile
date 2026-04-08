

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:productapp/service/weather_service.dart';

class TestWeatherController extends GetxController{

  final WeatherService _service = WeatherService();

  var isLoading = false.obs;
  var foreCast = <dynamic>[].obs;
  var errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchForecast();
  }

  Future<void> fetchForecast() async {
    isLoading.value = true;
    update();
    try {
      final data = await _service.fetchForecast('Ulaanbaatar');
      foreCast.value = data;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
      update();
    }
  }

  final List<String> _monDayNames = ["Да", "Мя", "Лха", "Пү", "Ба", "Бя", "Ня"];
  // groupData = temprature aa hadgalaad average temp butsaana;
  // dayDateMap = ['2026-03-19']

List<Map<String,dynamic>> get finalForecast {
  if(foreCast.isEmpty) return [];
  Map<String , List<double>> groupedData = {};
  Map<String , DateTime> dayDateMap = {};

  for(var item in foreCast) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(item['dt']*1000); //(2026, 3, 19, 6, 0, 0)
    String datekey = "${date.year}-${date.month}-${date.day}"; // "2026-3-19"

    if(!groupedData.containsKey(datekey)){
      groupedData[datekey] = [];
      dayDateMap[datekey] = date;
    }
    groupedData[datekey]!.add((item['main']['temp'] as num).toDouble());
    // ['2026-03-19']:['3.19']
  }
  // ['2026-03-19']:(2026, 3, 19,  6, 0, 0)
  List<Map<String,dynamic>> result = [];
  var sortedKeys  = dayDateMap.keys.toList()
      ..sort((a,b)=> dayDateMap[a]!.compareTo(dayDateMap[b]!));


  for (var key in sortedKeys.take(5)){
      double avgtemp = groupedData[key]!.reduce((a,b)=> a+b)/ groupedData[key]!.length;
      DateTime date = dayDateMap[key]!;
      String dayLabel = _monDayNames[date.weekday - 1];
      result.add({'temp': avgtemp , 'label': dayLabel});
  }
  return result;

}

}