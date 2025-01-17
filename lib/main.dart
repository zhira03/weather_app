import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/WeatherProvider.dart';
import 'package:weather_app/screens/weatherHome.dart';

void main() async {
  await dotenv.load(fileName: "assets/config/.env");
  runApp(
    MultiProvider(
      providers:[
        ChangeNotifierProvider(create: (_) => WeatherProvider()..fetchWeather()),
      ],
      child: const MyApp(),
      ),
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Weatherhome(),
    );
  }
}