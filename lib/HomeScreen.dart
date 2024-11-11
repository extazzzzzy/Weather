import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weatherapi/weatherapi.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController cityController = TextEditingController();
  WeatherRequest wr = WeatherRequest('01543779bf7e4787b46140740241111', language: Language.russian);
  String currentCountry = ''; // страна
  String currentCity = ''; // город
  String currentTemperature = ''; // темп в цельсиях min
  String currentWindMin = ''; // минимальный ветер в км ч
  String currentWindMax = ''; // макс ветер в км ч
  String currentFeelTemperature = ''; // температура по ощущениям с учетом ветра
  String currentUrlImage = '';

  void getCurrentWeather() async {
    currentCity = cityController.text;
    if (currentCity.isEmpty) {
      return;
    }

    // ForecastWeather fw = await wr.getForecastWeatherByCityName(currentCity);
    // ForecastDayData forecastDay = fw.forecast[0];
    // print(forecastDay.day.maxtempC);

    RealtimeWeather currentWeather = await wr.getRealtimeWeatherByCityName(currentCity);
    setState(() {
      currentCountry = utf8.decode(currentWeather.location.country!.runes.toList()) + ', ';
      currentCity = utf8.decode(currentWeather.location.name!.runes.toList());
      currentTemperature = currentWeather.current.tempC.toString() + '°';
      currentWindMin = 'Скорость ветра: ' + currentWeather.current.windKph.toString() + ' км/ч';
      currentWindMax = 'Порывы ветра до: ' + currentWeather.current.gustKph.toString() + ' км/ч';
      currentFeelTemperature = 'Ощущается как: ' + currentWeather.current.feelslikeC.toString() + '°';

      currentUrlImage = currentWeather.current.condition.icon.toString().replaceAll('64x64', '128x128');
      print(currentUrlImage);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Прогноз погоды',
          style: TextStyle(
            fontFamily: 'DushaRegular',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Color.fromRGBO(224, 255, 255, 1),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Center(
          child: Column(
            children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: cityController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Найти город',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.lightBlueAccent,
                              width: 4,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.lightBlueAccent,
                              width: 4,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 4,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          fontFamily: 'DushaRegular',
                          fontSize: 20,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        getCurrentWeather();
                      },
                    ),
                  ],
                ),
              Row (
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    currentCountry,
                    style: TextStyle(
                      fontFamily: 'DushaRegular',
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    currentCity,
                    style: TextStyle(
                      fontFamily: 'DushaRegular',
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
              Row (
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    currentTemperature,
                    style: TextStyle(
                      fontFamily: 'DushaRegular',
                      fontWeight: FontWeight.bold,
                      fontSize: 60,
                    ),
                  ),
                  Image.network(
                    'https:' + currentUrlImage,
                    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                      return Container();
                    },
                  )
                ],
              ),
              Text(
                currentWindMin,
                style: TextStyle(
                  fontFamily: 'DushaRegular',
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              Text(
                currentWindMax,
                style: TextStyle(
                  fontFamily: 'DushaRegular',
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              Text(
                currentFeelTemperature,
                style: TextStyle(
                  fontFamily: 'DushaRegular',
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color.fromRGBO(224, 255, 255, 1),
    );
  }
}
