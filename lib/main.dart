import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:mewather/libs/color_loader_3.dart';
import 'package:mewather/views/Home.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MeWeather",
      home: new Splash(),
      theme: ThemeData(
          primaryColor: Colors.lightBlue[800],
          accentColor: Colors.lightBlue[800],
          fontFamily: 'Raleway'),
      routes: {
        '/home': (BuildContext context) => Home(),
      },
    );
  }
}

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

// SingleTickerProviderStateMixin is used for animation
class SplashState extends State<Splash> {
  static final String apiKey = "a18494d4eee39d449c841066b7e55685";
  final _formKey = GlobalKey<FormState>();
  Map<String, double> _currentLocation;
  Map<String, double> _startLocation;
  Location _location = new Location();
  bool _permission = false;
  String error;
  StreamSubscription<Map<String, double>> _locationSubscription;

  String _weatherData;
  String _onBoarding;
  var bg = 'assets/bg/sunny.png';

  double lat;
  double long;
  var isLoading = true;

  @override
  void initState() {
    super.initState();
    setBg();
    _process();
  }

  void _loadWeatherData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var url =
          'https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${long}&APPID=${apiKey}&units=metric';
      print(url);
      http.get(url).then((response) {
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
        if (mounted) {
          setState(() {
            isLoading = false;

            if (prefs.getString('_weatherData') != "") {
              prefs.remove('_weatherData');
            }

            prefs.setString('_weatherData', response.body);
            Navigator.pop(context);
            Navigator.of(context).pushReplacementNamed('/home');
          });
        }
      });
    } catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        setState(() {
          isLoading = false;
        });
        String msg = e.response.data.toString();
        print("error " + e.response.data);
      }
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    Map<String, double> location;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Platform messages may fail, so we use a try/catch PlatformException.

    try {
      _permission = await _location.hasPermission();
      location = await _location.getLocation();

      setState(() {
        isLoading = true;
        lat = location["latitude"];
        long = location["longitude"];
        prefs.setDouble('_lat', lat);
        prefs.setDouble('_long', long);

        if (lat != null && long != null) {
          _loadWeatherData();
        }
      });

      error = null;
    } on PlatformException catch (e) {
      if (lat.toString() == "" || long.toString() == "") {
        lat = prefs.getDouble('_lat');
        long = prefs.getDouble('_long');
        if (lat != null && long != null) {
          _loadWeatherData();
        }
      }

      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
            'Permission denied - please ask the user to enable it from the app settings';
      }

      location = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
  }

  setBg() {
    setState(() {
      var list = [
        'assets/bg/sunny.png',
        'assets/bg/cloud.png',
        'assets/bg/fog.png',
        'assets/bg/rain.png',
        'assets/bg/snow.png',
        'assets/bg/thunder.png',
        'assets/bg/wind.png',
        'assets/bg/clearday.png',
        'assets/bg/night.png'
      ];

      final _random = new Random();
      bg = list[_random.nextInt(list.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 78.0,
        child: Image.asset('assets/images/logo.png'),
      ),
    );

    return new Stack(
      children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage(bg),
              fit: BoxFit.cover,
            ),
          ),
        ),
        new Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
              logo,
              SizedBox(height: 100.0),
              new Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[new ColorLoader3(radius: 20, dotRadius: 5)],
              ),
              SizedBox(height: 20.0)
            ]))
      ],
    );
  }

  void _process() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var latt = prefs.getDouble('_lat');
    var longg = prefs.getDouble('_long');

    var geoLocator = Geolocator();
    var status = await geoLocator.checkGeolocationPermissionStatus();

    if (status == GeolocationStatus.denied) {
      if (latt != null && longg != null) {
        _loadWeatherData();
      } else {
        initPlatformState();

        _locationSubscription =
            _location.onLocationChanged().listen((Map<String, double> result) {
          setState(() {
            _currentLocation = result;
          });
        });
      }
    } else if (status == GeolocationStatus.disabled) {
      if (latt != null && longg != null) {
        _loadWeatherData();
      } else {
        initPlatformState();

        _locationSubscription =
            _location.onLocationChanged().listen((Map<String, double> result) {
          setState(() {
            _currentLocation = result;
          });
        });
      }
    } else if (status == GeolocationStatus.restricted) {
      if (latt != null && longg != null) {
        _loadWeatherData();
      } else {
        initPlatformState();

        _locationSubscription =
            _location.onLocationChanged().listen((Map<String, double> result) {
          setState(() {
            _currentLocation = result;
          });
        });
      }
    } else if (status == GeolocationStatus.unknown) {
      if (latt != null && longg != null) {
        _loadWeatherData();
      } else {
        initPlatformState();

        _locationSubscription =
            _location.onLocationChanged().listen((Map<String, double> result) {
          setState(() {
            _currentLocation = result;
          });
        });
      }
    }
    // Unknown
    else if (status == GeolocationStatus.granted) {
      initPlatformState();

      _locationSubscription =
          _location.onLocationChanged().listen((Map<String, double> result) {
        setState(() {
          _currentLocation = result;
        });
      });
    }
  }
}
