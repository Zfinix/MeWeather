import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:mewather/models/Weather.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

// SingleTickerProviderStateMixin is used for animation
class HomeState extends State<Home> {
  
  String date = '';
  String bg = 'assets/bg/rain.png';
  String iconc = 'assets/weathercons/rain.png';
 
  var desc = "";
  var city = "";
  var weatherx;
  
  int humidity = 0;
  int pressure = 0;
  int temp = 0;

  double humidity2 = 0; 
  double pressure2 = 0;
  double windspeed = 0, windspeed2 = 0;

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    final dots = Hero(
      tag: 'hero',
      child: Image.asset('assets/icons/dots.png', scale: 3),
    );

    final icon = Hero(
      tag: 'hero',
      child: Image.asset(iconc, scale: 4),
    );

    final menu = Hero(
      tag: 'hero',
      child: Image.asset('assets/icons/menu.png', scale: 3.7),
    );

    final line = Hero(
      tag: 'hero',
      child: Image.asset('assets/icons/line.png', scale: 3.7),
    );

    final wind = LinearProgressIndicator(
      backgroundColor: Colors.white24,
      value: windspeed2,
    );
    final pressurec = LinearProgressIndicator(
      backgroundColor: Colors.white24,
      value: pressure2,
    );
    final humidityc = LinearProgressIndicator(
      backgroundColor: Colors.white24,
      value: humidity2,
    );
    return new Material(
        type: MaterialType.transparency,
        child: Stack(
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage(bg),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(0),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        menu,
                        SizedBox(width: 20),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        dots,
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(children: <Widget>[
                          Text(
                            city,
                            style: TextStyle(
                              fontSize: 34,
                              color: Colors.white,
                            ),
                          ),
                        ]),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            SizedBox(height: 9),
                            Text(date,
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            SizedBox(height: 68),
                            Text(temp.toString() + "º",
                                style: TextStyle(
                                  fontSize: 72,
                                  color: Colors.white,
                                ))
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        SizedBox(width: 10),
                        icon,
                        SizedBox(width: 9),
                        Text(desc,
                            style: TextStyle(
                              fontSize: 19,
                              color: Colors.white,
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            SizedBox(height: 54),
                            line,
                            SizedBox(height: 20),
                            Row(
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      Text("Wind",
                                          style: TextStyle(
                                            fontSize: 9,
                                            color: Colors.white,
                                          )),
                                      SizedBox(height: 12),
                                      Text(windspeed.toString(),
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.white,
                                          )),
                                      SizedBox(height: 10),
                                      Text("km/h",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          )),
                                      SizedBox(height: 7),
                                      SizedBox(
                                        height: 2,
                                        width: 80,
                                        child: wind,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      Text("Pressure",
                                          style: TextStyle(
                                            fontSize: 9,
                                            color: Colors.white,
                                          )),
                                      SizedBox(height: 12),
                                      Text(pressure.toString(),
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.white,
                                          )),
                                      SizedBox(height: 10),
                                      Text("kPa",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          )),
                                      SizedBox(height: 7),
                                      SizedBox(
                                        height: 2,
                                        width: 80,
                                        child: pressurec,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      Text("Humidity",
                                          style: TextStyle(
                                            fontSize: 9,
                                            color: Colors.white,
                                          )),
                                      SizedBox(height: 12),
                                      Text(humidity.toString(),
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.white,
                                          )),
                                      SizedBox(height: 10),
                                      Text("%",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          )),
                                      SizedBox(height: 7),
                                      SizedBox(
                                        height: 2,
                                        width: 80,
                                        child: humidityc,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  void _loadWeatherData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String response = prefs.getString('_weatherData');
    print(prefs.getString('_weatherData') ?? "ERROR");

    int i = 0;
    List<Weather> list = List();

    Map dataMap = jsonDecode(response);
    var d = WeatherData.fromJson(dataMap);

    list = d.weather;

    setState(() {
      temp = d.main.temp;
      pressure = d.main.pressure;
      pressure2 = pressure / 500;

      humidity = d.main.humidity;
      humidity2 = humidity / 100;

      windspeed = d.wind.speed;
      windspeed2 = windspeed / 10;

      desc = list[i].main;
      int a = d.sys.sunrise;
      int b = d.sys.sunset;
      var night = false;

      if (desc.contains("rain") || desc.contains("drizzle")) {
        bg = 'assets/bg/rain.png';
        iconc = 'assets/weathercons/rain.png';
      }

      if (desc.contains("thunder")) {
        bg = 'assets/bg/thunder.png';
        iconc = 'assets/weathercons/thunder.png';
      }

      if (desc.contains("haze")) {
        bg = 'assets/bg/fog.png';
        iconc = 'assets/weathercons/fog.png';
      }

      if (desc.contains("day") || a > b) {
        bg = 'assets/bg/clearday.png';
        iconc = 'assets/weathercons/clearsky.png';
      }

      if (a > b && temp > 40) {
        bg = 'assets/bg/sunny.png';
        iconc = 'assets/weathercons/sunny.png';
      }

      if (desc.contains("snow") || temp < 0) {
        bg = 'assets/bg/snow.png';
        iconc = 'assets/weathercons/snow.png';
      }

      if (desc.contains("wind")) {
        bg = 'assets/bg/wind.png';
        iconc = 'assets/weathercons/wind.png';
      }

      if (desc.contains("night") || a < b) {
        bg = 'assets/bg/night.png';
        night = true;
        iconc = 'assets/weathercons/cloudy_night.png';
      }

      if (desc.contains("cloud") && a < b) {
        bg = 'assets/bg/night.png';
        night = true;
        iconc = 'assets/weathercons/cloudy_night.png';
      }

      if (desc.contains("cloud") || a > b) {
        bg = 'assets/bg/cloud.png';
        iconc = 'assets/weathercons/cloud.png';
      }
      city = d.name;
      String m = "am";

      if (night) {
        m = "pm";
      }

      DateTime now = new DateTime.now();
      DateTime dated = new DateTime(now.year, now.month, now.day);

      date =
          "${dated.hour}:${dated.minute} ${m} - ${dated.weekday}, ${dated.day} ${dated.month} ${dated.year} ";
    });

    // weatherx = c.main;
  }
}
