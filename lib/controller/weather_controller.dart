import 'package:get/get.dart';
import '../service/weather_service.dart';

class WeatherController extends GetxController {
  final WeatherService _service = WeatherService();

  var weather = Rxn<dynamic>();
  var forecast = <dynamic>[].obs;
  var isLoading = false.obs;
  var errorMessage = RxnString();
  String lastSearchedCity = "Ulaanbaatar";

  final List<String> _monDayNames = ["Да", "Мя", "Лха", "Пү", "Ба", "Бя", "Ня"];

  List<Map<String, dynamic>> get processedForecast {
    if (forecast.isEmpty) return [];

    Map<String, List<double>> groupedData = {}; // temperature data
    Map<String, DateTime> dayDateMap = {}; // dawtagdagui udriin temp data
    print('--FORECASE_OVERVIEW--$forecast');
    for (var item in forecast) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
      String dateKey = "${date.year}-${date.month}-${date.day}";

      // dawtagdagui udruudiig dayDateMap-ruu hiih
      if (!groupedData.containsKey(dateKey)) {
        groupedData[dateKey] = [];
        dayDateMap[dateKey] = date;
      }
      groupedData[dateKey]!.add((item['main']['temp'] as num).toDouble());
    }

    print('--GROUPDATA--$groupedData}'); // 2026-3-19: [6.07, 1.52, -4.42]


    // orj irsen datagaa erembeleh heseg
    List<Map<String, dynamic>> result = [];
    var sortedKeys = dayDateMap.keys.toList()
      ..sort((a, b) => dayDateMap[a]!.compareTo(dayDateMap[b]!));

    // 5 udriig awah heseg
    for (var key in sortedKeys.take(5)) {
      double avgTemp =
          groupedData[key]!.reduce((a, b) => a + b) / groupedData[key]!.length; // dundaj temp
      DateTime date = dayDateMap[key]!; // tuhain udruu gargaj ireed
      String dayLabel = _monDayNames[date.weekday - 1];  // label deeree zaaj ugnu
      result.add({'temp': avgTemp, 'label': dayLabel});
    }

    return result;

    // [
    //   {'temp': 13.24, 'label': 'Да'},
    //   {'temp': 11.80, 'label': 'Мя'},
    //   {'temp': 9.50,  'label': 'Лха'},
    //   {'temp': 14.10, 'label': 'Пү'},
    //   {'temp': 16.30, 'label': 'Ба'},
    // ]
  }

  @override
  void onInit() {
    super.onInit();
    fetchWeather(lastSearchedCity);
  }

  void fetchWeather([String? city]) async {
    isLoading.value = true;
    errorMessage.value = null;
    update();

    String cityToSearch = city ?? lastSearchedCity;
    lastSearchedCity = cityToSearch;

    try {
      weather.value = await _service.fetchWeather(cityToSearch);
      forecast.value = await _service.fetchForecast(cityToSearch);
    } catch (e) {
      errorMessage.value = e.toString().contains("Exception:")
          ? e.toString().split("Exception: ")[1]
          : "Цаг агаарын мэдээлэл авахад алдаа гарлаа";
      weather.value = null;
      forecast.value = [];
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
