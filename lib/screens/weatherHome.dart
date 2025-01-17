import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/providers/WeatherProvider.dart';

class Weatherhome extends StatelessWidget {
  const Weatherhome({super.key});


  String getWeatherAnimation(String? mainCondition){
    if(mainCondition == null) return "assets/sunny.json";

    switch (mainCondition.toLowerCase()){
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/thunderclouds.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient:  LinearGradient(
            colors: [Color(0xFF74ABE2), Color(0xFF5571A6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            ),
        ),
      child: Center(
        child: weatherProvider.isLoading 
        ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingAnimationWidget.halfTriangleDot(
                      color: Colors.white,
                      size: 100,
                    ),
            const SizedBox(height: 20,),
            const Text(
              'Fetching Your Weather Info....',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),  
          ],
        )
        : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              weatherProvider.weatherModel?.cityName??"I can't find you",
              style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
              ),
            ),
            Lottie.asset(
              getWeatherAnimation(weatherProvider.weatherModel?.mainCondition),
              height: 200,
            ),
            Text(
              "${weatherProvider.weatherModel?.temperature.round() ?? "0"} °C",
              style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow,
                      ),
            ),
            Text(
                (() {
                if (weatherProvider.weatherModel == null) {
                  print("weatherModel is null");
                  return "Weather data not available";
                } else if (weatherProvider.weatherModel?.mainCondition == null) {
                  print("mainCondition is null");
                  return "Condition data not available";
                } else {
                  return weatherProvider.weatherModel?.mainCondition ?? "What's it feel like today?";
                }
                })(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
            ),
          ],
        )
      ),
      )
    );
  }
}