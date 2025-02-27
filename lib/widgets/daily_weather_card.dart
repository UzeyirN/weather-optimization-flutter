import 'package:flutter/material.dart';
import 'package:weather_optimizayion/styles/styles.dart';

class DailyWeatherCard extends StatelessWidget {
  const DailyWeatherCard(
      {super.key,
      required this.weatherIcon,
      required this.temperature,
      required this.date});

  final String weatherIcon;
  final double temperature;
  final String date;

  @override
  Widget build(BuildContext context) {
    List<String> weekdays = [
      'MON',
      'TUE',
      'WED',
      'THU',
      'FRI',
      'SAT',
      'SUN',
    ];

    String weekday = weekdays[DateTime.parse(date).weekday - 1];

    return Card(
      color: Colors.transparent,
      child: SizedBox(
        height: 100,
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              'https://openweathermap.org/img/wn/$weatherIcon.png',
            ),
            Text(
              '$temperature°',
              style: cardTempTextStyle,
            ),
            Text(
              weekday,
              style: cardDateTextStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
