import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: const HomePage(title: 'Flutter User Location'),
      );
}

class HomePage extends StatelessWidget {
  const HomePage({required this.title, Key? key}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(elevation: 0, title: Text(title)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Current Location of the User'),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text('Get Current Location'),
                onPressed: _getCurrentLocation,
              )
            ],
          ),
        ),
      );

  Future<Position> _getCurrentLocation() async {
    final bool isLocationServiceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!isLocationServiceEnabled) {
      return Future<Position>.error('Location service is disabled.');
    }

    LocationPermission locationPermission = await Geolocator.checkPermission();

    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();

      if (locationPermission == LocationPermission.denied) {
        return Future<Position>.error('Location permission is denied.');
      }
    }

    if (locationPermission == LocationPermission.deniedForever) {
      return Future<Position>.error(
        'Location permission is permanently denied, we can\'t request for permission.',
      );
    }

    return Geolocator.getCurrentPosition();
  }
}
