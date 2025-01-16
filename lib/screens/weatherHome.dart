import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';

class Weatherhome extends StatefulWidget {
  const Weatherhome({super.key});

  @override
  State<Weatherhome> createState() => _WeatherhomeState();
}

class _WeatherhomeState extends State<Weatherhome> {

  final _weatherService = WeatherService( apiKey: '1a23e1dccdbcac69325e16b819b44ed4');
  WeatherModel ? _weatherModel;

  _fetchWeather() async{
    String cityName = await _weatherService.getCurrentLocation();

    try{
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weatherModel = weather;
      });
    }catch (e){
      print(e);
    }
  }

  @override
  void initState(){
    super.initState();
    _fetchWeather();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_weatherModel?.cityName ?? "Loading City....."),

            Lottie.asset('assets/cloudy.json'),
        
            Text("${_weatherModel?.temperature.round()?? "0"} *C")
          ],
        ),
      ),
    );
  }
}