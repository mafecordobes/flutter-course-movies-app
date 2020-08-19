import 'package:flutter/material.dart';
import 'package:movies_course/src/pages/home_page.dart';
import 'package:movies_course/src/pages/movie_detail_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Películas',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => HomePage(),
        'detalle': (BuildContext context) => MovieDetail(),
      },
    );
  }
}
