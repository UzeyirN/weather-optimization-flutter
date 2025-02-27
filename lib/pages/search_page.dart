import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_optimizayion/styles/styles.dart';

import '../consts/consts.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String selectedCity = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 100),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: pageDecoration('map'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: searchInputDecoration,
              onChanged: (newValue) {
                selectedCity = newValue;
              },
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                http.Response response = await http.get(
                  Uri.parse(
                      'https://api.openweathermap.org/data/2.5/weather?q=$selectedCity&appid=$key&units=metric'),
                );

                if (response.statusCode == 200) {
                  Navigator.pop(context, selectedCity);
                } else {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Location not found"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            child: const Text(
                              "OK",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text('SEARCH'),
            ),
          ],
        ),
      ),
    );
  }
}
