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

class HomePage extends StatefulWidget {
  const HomePage({required this.title, Key? key}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? _position;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(elevation: 0, title: Text(widget.title)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _position == null
                    ? 'Waiting for location...'
                    : 'Latitude: ${_position?.latitude}, Longitude: ${_position?.longitude}',
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text('Get Current Location'),
                onPressed: () async {
                  _position = await _getCurrentLocation();

                  setState(() {});

                  _updateLiveLocation();
                },
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

  void _updateLiveLocation() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position newPosition) => _position = newPosition);

    setState(() {});
  }
}
