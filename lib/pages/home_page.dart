import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_optimizayion/consts/consts.dart';
import 'package:weather_optimizayion/pages/search_page.dart';
import 'package:weather_optimizayion/styles/styles.dart';
import 'package:weather_optimizayion/widgets/daily_weather_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String weatherCover = 'home';
  String location = 'Baku';
  double? temperature;
  String? weatherIcon;
  var locationData;
  Position? devicePosition;

  List<String> icons = [
    '01d',
    '01d',
    '01d',
    '01d',
    '01d',
  ];

  List<double> temperatures = [
    20.0,
    20.0,
    20.0,
    20.0,
    20.0,
  ];

  List<String> dates = [
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
    'SUN',
  ];

  Future<void> getLocationDataByLocation() async {
    locationData = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$key&units=metric'),
    );

    var locationDataParsed = jsonDecode(locationData.body);

    setState(() {
      location = locationDataParsed['name'];
      temperature = locationDataParsed['main']['temp'];
      weatherIcon = locationDataParsed['weather'][0]['icon'];
      weatherCover = locationDataParsed['weather'][0]['main'];
    });
  }

  Future<void> getDevicePosition() async {
    try {
      devicePosition = await _determinePosition();
    } catch (e) {
      print('devicePos error: $e');
    }
  }

  Future<void> getLocationDataByLatLon() async {
    if (devicePosition != null) {
      locationData = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/weather?lat=${devicePosition!.latitude}&lon=${devicePosition!.longitude}&appid=$key&units=metric'),
      );

      var locationDataParsed = jsonDecode(locationData.body);

      setState(() {
        location = locationDataParsed['name'];
        temperature = locationDataParsed['main']['temp'];
        weatherIcon = locationDataParsed['weather'][0]['icon'];
        weatherCover = locationDataParsed['weather'][0]['main'];
      });
    }
  }

  Future<void> getForecastDataByLatLon() async {
    var forecastData = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?lat=${devicePosition!.latitude}&lon=${devicePosition!.longitude}&appid=$key&units=metric'),
    );

    var forecastDataParsed = jsonDecode(forecastData.body);

    icons.clear();
    temperatures.clear();
    dates.clear();

    setState(() {
      for (int i = 7; i < 40; i += 8) {
        icons.add(forecastDataParsed['list'][i]['weather'][0]['icon']);
        temperatures.add(forecastDataParsed['list'][i]['main']['temp']);
        dates.add(forecastDataParsed['list'][i]['dt_txt']);
      }
    });
  }

  Future<void> getForecastDataByLocation() async {
    var forecastData = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$location&appid=$key&units=metric'),
    );

    var forecastDataParsed = jsonDecode(forecastData.body);

    temperatures.clear();
    icons.clear();
    dates.clear();

    setState(() {
      for (int i = 7; i < 40; i += 8) {
        icons.add(forecastDataParsed['list'][i]['weather'][0]['icon']);
        temperatures.add(forecastDataParsed['list'][i]['main']['temp']);
        dates.add(forecastDataParsed['list'][i]['dt_txt']);
      }
    });
  }

  bool isLoading = true;

  void initialState() async {
    try {
      await getDevicePosition();
      await getLocationDataByLatLon();
      await getForecastDataByLatLon();
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false; //
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initialState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? loading
        : Container(
            width: MediaQuery.of(context).size.width,
            decoration: pageDecoration(weatherCover),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  'https://openweathermap.org/img/wn/$weatherIcon@4x.png',
                ),
                Text(
                  '$temperature° C',
                  style: temperatureTextStyle,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      location,
                      style: locationTextStyle,
                    ),
                    IconButton(
                      onPressed: () async {
                        final selectedCity = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchPage(),
                          ),
                        );

                        location = selectedCity;
                        getLocationDataByLocation();
                        getForecastDataByLocation();
                      },
                      icon: searchIcon,
                    ),
                  ],
                ),
                cardWrapper(context),
              ],
            ),
          );
  }

  SizedBox cardWrapper(BuildContext context) {
    List<DailyWeatherCard> cards = [];

    int itemCount = [icons.length, temperatures.length, dates.length]
        .reduce((value, element) => value < element ? value : element);

    for (int i = 0; i < itemCount; ++i) {
      cards.add(
        DailyWeatherCard(
          weatherIcon: icons[i],
          temperature: temperatures[i],
          date: dates[i],
        ),
      );
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.2,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: cards,
      ),
    );
  }

  //GEOLOCATOR
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
