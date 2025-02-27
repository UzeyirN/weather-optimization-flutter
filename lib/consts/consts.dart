import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

String key = '4c7067d32c54af87f1ac1ea57f601529';

final loading = SpinKitFadingCircle(
  itemBuilder: (BuildContext context, int index) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: index.isEven ? Colors.white : Colors.blueAccent,
      ),
    );
  },
);
