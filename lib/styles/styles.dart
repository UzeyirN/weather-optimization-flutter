import 'package:flutter/material.dart';

TextStyle temperatureTextStyle = TextStyle(
  fontSize: 70,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  shadows: <Shadow>[
    Shadow(
      offset: Offset(5, 3),
      blurRadius: 3.0,
      color: Colors.black54,
    ),
  ],
);

TextStyle locationTextStyle = TextStyle(
  fontSize: 35,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  shadows: <Shadow>[
    Shadow(
      offset: Offset(3, 2),
      blurRadius: 1.0,
      color: Colors.black54,
    ),
  ],
);

Icon searchIcon = Icon(
  Icons.search,
  size: 30,
  color: Colors.white,
  shadows: <Shadow>[
    Shadow(
      offset: Offset(3, 2),
      blurRadius: 1.0,
      color: Colors.black54,
    ),
  ],
);

BoxDecoration pageDecoration(String image) {
  return BoxDecoration(
    image: DecorationImage(
      fit: BoxFit.cover,
      image: AssetImage('assets/$image.jpg'),
    ),
  );
}

InputDecoration searchInputDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide.none,
  ),
  hintText: 'Search location',
  hintStyle: TextStyle(
    color: Colors.black54,
    fontWeight: FontWeight.bold,
  ),
);

TextStyle cardTempTextStyle = TextStyle(
  fontSize: 24,
  color: Colors.white,
  fontWeight: FontWeight.bold,
  shadows: <Shadow>[
    Shadow(
      offset: Offset(4, 1),
      blurRadius: 3.0,
      color: Colors.black54,
    ),
  ],
);

TextStyle cardDateTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.white,
  fontWeight: FontWeight.w500,
  shadows: <Shadow>[
    Shadow(
      offset: Offset(2, 1),
      blurRadius: 3.0,
      color: Colors.black54,
    ),
  ],
);
