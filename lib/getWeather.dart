import '../network.dart';
import '../location.dart';
import 'constants.dart';

class WeatherModel {

  Future<dynamic> getCityWeather(String cityName) async {

    String url = '$ApiUrl?q=$cityName&appid=$ApiKey&units=metric';
    NetworkHelper networkHelper = NetworkHelper(url: url);
    var cityData = await networkHelper.getData();

    return cityData;

  }

  Future<dynamic> getLocationWeather() async {

    Location location = Location();

    await location.getCurrentLocation();

    String url =
        '$ApiUrl?lat=${location.latitude}&lon=${location.longitude}&appid=$ApiKey&units=metric';
    NetworkHelper networkHelper = NetworkHelper(url: url);
    var networkData = await networkHelper.getData();

    return networkData;

  }


  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }


}
