class WeatherModel {
  final String cityName;
  final double temperature;
  final String mainCoordinates;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.mainCoordinates,
    });

  factory WeatherModel.fromJson(Map<String, dynamic> json){
    return WeatherModel(
      cityName: json['name'], 
      temperature: json['main']['temp'].toDouble(), 
      mainCoordinates: json['weather'][0]['main']
        );
  }

  get mainCondition => null;

}