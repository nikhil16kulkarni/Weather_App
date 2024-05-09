// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_switch/flutter_switch.dart';

void main() {
  runApp(MaterialApp(
    home: MainPage(),
  ));
}

class MainPage extends StatefulWidget{
  const MainPage({Key? key}) : super(key: key);

  @override
  _HomePage createState()=> _HomePage();
}

class _HomePage extends State{
  @override
  void initState()
  {
    super.initState();
    fetchWeatherDetails(placeInput);
  }
  // MainApp({super.key});

  String temp = "0";
  String tempC = "0";
  String tempF = "0";
  String place = "NA";
  String dateTime = "0000-00-00 00:00";
  String condition = "NA";

  List<String> forcastDays = ["0000-00-00", "0000-00-00", "0000-00-00", "0000-00-00", "0000-00-00"];
  List<String> forcastTemps = ["0", "0", "0", "0", "0"];
  List<String> forcastTempsC = ["0", "0", "0", "0", "0"];
  List<String> forcastTempsF = ["0", "0", "0", "0", "0"];
  List<String> forcastCondition = ["NA", "NA", "NA", "NA", "NA"];
  List<String> forcastIcon = ["assets/cloudy.png", "assets/cloudy.png", "assets/cloudy.png", "assets/cloudy.png", "assets/cloudy.png"];

  DateFormat format = DateFormat.yMMMMd('en_US');
  DateFormat format2 = DateFormat.jm();

  List<Color> forcastColor = [Color.fromARGB(255, 60, 61, 60), Color.fromARGB(193, 60, 61, 60), Color.fromARGB(193, 60, 61, 60), Color.fromARGB(193, 60, 61, 60), Color.fromARGB(193, 60, 61, 60)];

  AssetImage bg = AssetImage("assets/night.png");

  String errorMsg = '';
  TextEditingController textFieldController = TextEditingController();

  String placeInput = "Bloomington";

  bool switchValue = true;

  String unit = "°C";

  bool searchBtnHover = false;
  bool refreshBtnHover = false;

  @override
  Widget build(BuildContext context) {
    // fetchWeatherDetails();
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: bg,
              fit: BoxFit.cover),
            ),
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          placePopup();
                        },
                        onHover: (val){
                          setState(() {
                            searchBtnHover = val;
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: (searchBtnHover)? const Color.fromARGB(255, 60, 61, 60) : Color.fromARGB(193, 60, 61, 60),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Image(
                            height: 5,
                            width: 5,
                            image: AssetImage("assets/location.png"),
                          )
                        ),
                      ),
                      Center(
                        child: FlutterSwitch(
                          width: 60.0,
                          height: 30.0,
                          valueFontSize: 15.0,
                          toggleSize: 30.0,
                          value: switchValue,
                          activeText: "°C",
                          inactiveText: "°F",
                          activeTextColor: Colors.white,
                          inactiveTextColor: Colors.white,
                          activeTextFontWeight: FontWeight.bold,
                          inactiveTextFontWeight: FontWeight.bold,
                          activeColor: const Color.fromARGB(193, 60, 61, 60),
                          inactiveColor: const Color.fromARGB(193, 60, 61, 60),
                          borderRadius: 30.0,
                          padding: 4.0,
                          showOnOff: true,
                          onToggle: (val) {
                            setState(() {
                              switchValue = val;
                              if(val){
                                unit = "°C";
                                temp = tempC;
                                forcastTemps = forcastTempsC;
                        
                              }else{
                                unit = "°F";
                                temp = tempF;
                                forcastTemps = forcastTempsF;
                              }                                
                            });
                          },
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          fetchWeatherDetails(placeInput);
                        },
                        onHover: (val){
                          setState(() {
                            refreshBtnHover = val;
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 40,                                         
                          decoration: BoxDecoration(
                            color: (refreshBtnHover)? const Color.fromARGB(255, 60, 61, 60) : Color.fromARGB(193, 60, 61, 60),
                            borderRadius: BorderRadius.circular(16),
                          ),                           
                          child: const Icon(
                            Icons.refresh,
                            color: Colors.white,                          
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 40.0),
                    // ignore: prefer_const_constructors
                    child: Text(place, style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Baloo2',
                    fontWeight:FontWeight.bold,
                    color: Colors.white,
                  ),),
                  ),
                  Text(condition, style: TextStyle(
                    fontSize: 10,
                    fontFamily: 'Baloo2',
                    fontWeight:FontWeight.bold,
                    color: Colors.white,
                  ),),
                  // ignore: prefer_const_constructors
                  Text('$temp$unit', style: TextStyle(
                    fontSize: 90,
                    fontFamily: 'Comfortaa',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),),
                  Text(dateTime, style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Baloo2',
                    fontWeight: FontWeight.bold,
                  ),),
                  const Padding(
                    padding: EdgeInsets.only(top: 240.0),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Today", style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Baloo2',
                        fontSize: 18,
                        fontWeight:FontWeight.bold,
                      ),),
                      Text("Next 5 Day's Forcast", style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Baloo2',
                        fontSize: 18,
                        fontWeight:FontWeight.bold,
                      ),),
                    ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: (){
                            changeTab(0);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50.0, right: 10.0),
                            child: Container(
                              height: 160,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(19), 
                                color: forcastColor[0],
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 1,
                                    blurRadius: 1, // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(top:5.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text(DateFormat('EEEE').format(DateTime.parse(forcastDays[0])), style: TextStyle(
                                        fontSize: 15, 
                                        fontFamily: 'Baloo2',
                                        color: Colors.white,
                                      ),),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Text(format.format(DateTime.parse(forcastDays[0])), style: TextStyle(
                                        fontSize: 15, 
                                        fontFamily: 'Baloo2',
                                        color: Colors.white,
                                      ),),
                                    ),
                                    Image(
                                      height: 40,
                                      image: AssetImage(forcastIcon[0]),
                                    ),
                                    Center(
                                      child: Text('${forcastTemps[0]}$unit', style: TextStyle(
                                        fontSize: 30, 
                                        fontFamily: 'Baloo2',
                                        color: Colors.white,
                                      ),),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            changeTab(1);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50.0, right: 10.0),
                            child: Container(
                              height: 160,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(19), 
                                color: forcastColor[1],
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 1,
                                    blurRadius: 1, // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(top:5.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text(DateFormat('EEEE').format(DateTime.parse(forcastDays[1])), style: TextStyle(
                                        fontSize: 15, 
                                        fontFamily: 'Baloo2',
                                        color: Colors.white,
                                      ),),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Text(format.format(DateTime.parse(forcastDays[1])), style: TextStyle(
                                        fontSize: 15, 
                                        fontFamily: 'Baloo2',
                                        color: Colors.white,
                                      ),),
                                    ),
                                    Image(
                                      height: 40,
                                      image: AssetImage(forcastIcon[1]),
                                    ),
                                    Center(
                                      child: Text('${forcastTemps[1]}$unit', style: TextStyle(
                                        fontSize: 30, 
                                        fontFamily: 'Baloo2',
                                        color: Colors.white,
                                      ),),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            changeTab(2);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50.0, right: 10.0),
                            child: Container(
                              height: 160,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(19), 
                                color: forcastColor[2],
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 1,
                                    blurRadius: 1, // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(top:5.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text(DateFormat('EEEE').format(DateTime.parse(forcastDays[2])), style: TextStyle(
                                        fontSize: 15, 
                                        fontFamily: 'Baloo2',
                                        color: Colors.white,
                                      ),),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Text(format.format(DateTime.parse(forcastDays[2])), style: TextStyle(
                                          fontSize: 15, 
                                          fontFamily: 'Baloo2',
                                          color: Colors.white,
                                        ),),
                                    ),
                                    Image(
                                      height: 40,
                                      image: AssetImage(forcastIcon[2]),
                                    ),
                                    Center(
                                      child: Text('${forcastTemps[2]}$unit', style: TextStyle(
                                        fontSize: 30, 
                                        fontFamily: 'Baloo2',
                                        color: Colors.white,
                                      ),),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                         InkWell(
                          onTap: (){
                            changeTab(3);
                          },
                          child:Padding(
                            padding: const EdgeInsets.only(top: 50.0, right: 10.0),
                            child: Container(
                              height: 160,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(19), 
                                color: forcastColor[3],
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 1,
                                    blurRadius: 1, // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(top:5.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text(DateFormat('EEEE').format(DateTime.parse(forcastDays[3])), style: TextStyle(
                                        fontSize: 15, 
                                        fontFamily: 'Baloo2',
                                        color: Colors.white,
                                      ),),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Text(format.format(DateTime.parse(forcastDays[3])), style: TextStyle(
                                          fontSize: 15, 
                                          fontFamily: 'Baloo2',
                                          color: Colors.white,
                                        ),),
                                    ),
                                    Image(
                                      height: 40,
                                      image: AssetImage(forcastIcon[3]),
                                    ),
                                    Center(
                                        child: Text('${forcastTemps[3]}$unit', style: TextStyle(
                                          fontSize: 30, 
                                          fontFamily: 'Baloo2',
                                          color: Colors.white,
                                        ),),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ),
                        InkWell(
                          onTap: (){
                            changeTab(4);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50.0, right: 10.0),
                            child: Container(
                              height: 160,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(19), 
                                color: forcastColor[4],
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 1,
                                    blurRadius: 1, // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(top:5.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text(DateFormat('EEEE').format(DateTime.parse(forcastDays[4])), style: TextStyle(
                                        fontSize: 15, 
                                        fontFamily: 'Baloo2',
                                        color: Colors.white,
                                      ),),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Text(format.format(DateTime.parse(forcastDays[4])), style: TextStyle(
                                          fontSize: 15, 
                                          fontFamily: 'Baloo2',
                                          color: Colors.white,
                                        ),),
                                    ),
                                    Image(
                                      height: 40,
                                      image: AssetImage(forcastIcon[4]),
                                    ),
                                    Center(
                                      child: Text('${forcastTemps[4]}$unit', style: TextStyle(
                                        fontSize: 30, 
                                        fontFamily: 'Baloo2',
                                        color: Colors.white,
                                      ),),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ),
      ),
    );
  }

  //used weather api
  // void fetchWeatherDetails(placeInput) async {
  //   // print(placeInput);
  //   String URL = "http://api.weatherapi.com/v1/forecast.json?key=1ccbce3385f646cb823233701242604&q=$placeInput&days=6&aqi=no&alerts=no";
  //   final URI = Uri.parse(URL);
  //   final response = await http.get(URI);
  //   final body = response.body;
  //   final json = jsonDecode(body);
  //   // print(json);

  //   setState(() {
  //     temp = json["current"]["temp_c"].toString();
  //     tempC = temp;
  //     tempF = json["current"]["temp_f"].toString();
  //     place = json["location"]["name"].toString();
  //     dateTime = json["location"]["localtime"].toString();
  //     condition = json["current"]["condition"]["text"].toString();

  //     if(condition.toLowerCase().contains("rain")){
  //       bg = AssetImage("assets/rainyDayBG.png");
  //     }else if(condition.toLowerCase().contains("cloud")){
  //       bg = AssetImage("assets/cloudyBG.png");
  //     }else if(condition.toLowerCase().contains("clear") || condition.toLowerCase().contains("sunny") || condition.toLowerCase().contains("sun")){
  //       bg = AssetImage("assets/sunBG.png");
  //     }else if(condition.toLowerCase().contains("wind")){
  //       bg = AssetImage("assets/windyBG.png");
  //     }else if(condition.toLowerCase().contains("hot") || condition.toLowerCase().contains("temp")){
  //       bg = AssetImage("assets/hotBG.png");
  //     }else if(condition.toLowerCase().contains("snow") || condition.toLowerCase().contains("cold")){
  //       bg = AssetImage("assets/snowflakeBG.png");
  //     }else if(condition.toLowerCase().contains("drizzle")){
  //       bg = AssetImage("assets/rainyDayBG.png");
  //     }

  //     for (var i = 0; i < 5; i++) {
  //       forcastDays[i] = json["forecast"]["forecastday"][i+1]["date"].toString();
  //       forcastCondition[i] = json["forecast"]["forecastday"][i+1]["day"]["condition"]["text"].toString();
  //       forcastTemps[i] = json["forecast"]["forecastday"][i+1]["day"]["avgtemp_c"].toString();

  //       forcastTempsC = forcastTemps;
  //       forcastTempsF[i] = json["forecast"]["forecastday"][i+1]["day"]["avgtemp_f"].toString();
                               

  //       if(forcastCondition[i].toLowerCase().contains("rain")){
  //         forcastIcon[i] = "assets/rainyDay.png";
  //       }else if(forcastCondition[i].toLowerCase().contains("cloud")){
  //         forcastIcon[i] = "assets/cloudy.png";
  //       }else if(forcastCondition[i].toLowerCase().contains("clear") || forcastCondition[i].toLowerCase().contains("sun")){
  //         forcastIcon[i] = "assets/sun.png";
  //       }else if(forcastCondition[i].toLowerCase().contains("wind")){
  //         forcastIcon[i] = "assets/windy.png";
  //       }else if(forcastCondition[i].toLowerCase().contains("hot") || forcastCondition[i].toLowerCase().contains("temp")){
  //         forcastIcon[i] = "assets/hot.png";
  //       }else if(forcastCondition[i].toLowerCase().contains("snow") || forcastCondition[i].toLowerCase().contains("cold")){
  //         forcastIcon[i] = "assets/snowflake.png";
  //       }else if(forcastCondition[i].toLowerCase().contains("drizzle")){
  //         forcastIcon[i] = "assets/rainyDay.png";
  //       }
  //     }
  //   });
  // }

//using open weather api
void fetchWeatherDetails(String placeInput) async {
  // URLs for the current weather and forecast data
  String apiKey = "bb1bbacb9132198200ca2e2a1ccf8803"; 
  String currentWeatherUrl = "https://api.openweathermap.org/data/2.5/weather?q=$placeInput&units=metric&appid=$apiKey"; //current api
  String forecastUrl = "https://api.openweathermap.org/data/2.5/forecast?q=$placeInput&units=metric&appid=$apiKey"; //forecast api

  Uri currentWeatherUri = Uri.parse(currentWeatherUrl);
  Uri forecastUri = Uri.parse(forecastUrl);

  try {
    var responses = await Future.wait([
      http.get(currentWeatherUri),
      http.get(forecastUri)
    ]);

    var currentWeatherResponse = responses[0];
    var forecastResponse = responses[1];

    var currentWeatherData = jsonDecode(currentWeatherResponse.body);
    var forecastData = jsonDecode(forecastResponse.body);

    if (currentWeatherResponse.statusCode != 200 || forecastResponse.statusCode != 200) {
      String errorMessage = "Failed to fetch data: ";
      if (currentWeatherResponse.statusCode != 200) {
        errorMessage += currentWeatherData['message'];
      } else {
        errorMessage += forecastData['message'];
      }
      setState(() {
        errorMsg = errorMessage;
      });
      return;
    }
    setState(() {
      tempC = currentWeatherData["main"]["temp"].toString();
      tempF = (double.parse(tempC) * 1.8 + 32).toStringAsFixed(2);
      temp = tempC;
      place = currentWeatherData["name"];
      // dateTime = DateTime.now().toString();
      dateTime = DateFormat('yyyy-MM-dd').format(DateTime.now()); // to show only date
      condition = currentWeatherData["weather"][0]["description"];
       if(condition.toLowerCase().contains("rain")){
        bg = AssetImage("assets/rainyDayBG.png");
      }else if(condition.toLowerCase().contains("cloud")){
        bg = AssetImage("assets/cloudyBG.png");
      }else if(condition.toLowerCase().contains("clear") || condition.toLowerCase().contains("sunny") || condition.toLowerCase().contains("sun")){
        bg = AssetImage("assets/sunBG.png");
      }else if(condition.toLowerCase().contains("wind")){
        bg = AssetImage("assets/windyBG.png");
      }else if(condition.toLowerCase().contains("hot") || condition.toLowerCase().contains("temp")){
        bg = AssetImage("assets/hotBG.png");
      }else if(condition.toLowerCase().contains("snow") || condition.toLowerCase().contains("cold")){
        bg = AssetImage("assets/snowflakeBG.png");
      }else if(condition.toLowerCase().contains("drizzle")){
        bg = AssetImage("assets/rainyDayBG.png");
      }

      List<dynamic> forecastList = forecastData["list"];
      for (int i = 0; i < 5; i++) {
        int index = i * 8;  // Data for each 24 hours
        DateTime date = DateTime.parse(forecastList[index]["dt_txt"]);
        forcastDays[i] = DateFormat('yyyy-MM-dd').format(date);
        forcastCondition[i] = forecastList[index]["weather"][0]["description"];
        forcastTemps[i] = forecastList[index]["main"]["temp"].toString();
        forcastTempsC[i] = forecastList[index]["main"]["temp"].toString();
        //print(forcastTempsC[i]);
        forcastTempsF[i] = (double.parse(forcastTempsC[i]) * 1.8 + 32).toStringAsFixed(2);
        if(forcastCondition[i].toLowerCase().contains("rain")){
          forcastIcon[i] = "assets/rainyDay.png";
        }else if(forcastCondition[i].toLowerCase().contains("cloud")){
          forcastIcon[i] = "assets/cloudy.png";
        }else if(forcastCondition[i].toLowerCase().contains("clear") || forcastCondition[i].toLowerCase().contains("sun")){
          forcastIcon[i] = "assets/sun.png";
        }else if(forcastCondition[i].toLowerCase().contains("wind")){
          forcastIcon[i] = "assets/windy.png";
        }else if(forcastCondition[i].toLowerCase().contains("hot") || forcastCondition[i].toLowerCase().contains("temp")){
          forcastIcon[i] = "assets/hot.png";
        }else if(forcastCondition[i].toLowerCase().contains("snow") || forcastCondition[i].toLowerCase().contains("cold")){
          forcastIcon[i] = "assets/snowflake.png";
        }else if(forcastCondition[i].toLowerCase().contains("drizzle")){
          forcastIcon[i] = "assets/rainyDay.png";
        }
      }
    });
  } catch (e) {
    //Handle any errors that occur during fetch
    setState(() {
      errorMsg = "Error fetching data: $e";
    });
  }
}



  void changeTab(index){
    //change the colors of the tab based on the index
    setState(() {
      temp = forcastTemps[index].toString();
      dateTime = forcastDays[index].toString();
      condition = forcastCondition[index].toString();

      if(index == 0){
        forcastColor[0] = Color.fromARGB(255, 60, 61, 60);
        forcastColor[1] = Color.fromARGB(193, 60, 61, 60);
        forcastColor[2] = Color.fromARGB(193, 60, 61, 60);
        forcastColor[3] = Color.fromARGB(193, 60, 61, 60);
        forcastColor[4] = Color.fromARGB(193, 60, 61, 60);
      }else if(index == 1){
        forcastColor[0] = Color.fromARGB(193, 60, 61, 60);
        forcastColor[1] = Color.fromARGB(255, 60, 61, 60);
        forcastColor[2] = Color.fromARGB(193, 60, 61, 60);
        forcastColor[3] = Color.fromARGB(193, 60, 61, 60);
        forcastColor[4] = Color.fromARGB(193, 60, 61, 60);
      }else if(index == 2){
        forcastColor[0] = Color.fromARGB(193, 60, 61, 60);
        forcastColor[1] = Color.fromARGB(193, 60, 61, 60);
        forcastColor[2] = Color.fromARGB(255, 60, 61, 60);
        forcastColor[3] = Color.fromARGB(193, 60, 61, 60);
        forcastColor[4] = Color.fromARGB(193, 60, 61, 60);
      }else if(index == 3){
        forcastColor[0] = Color.fromARGB(193, 60, 61, 60);
        forcastColor[1] = Color.fromARGB(193, 60, 61, 60);
        forcastColor[2] = Color.fromARGB(193, 60, 61, 60);
        forcastColor[3] = Color.fromARGB(255, 60, 61, 60);
        forcastColor[4] = Color.fromARGB(193, 60, 61, 60);
      }else if(index == 4){
        forcastColor[0] = Color.fromARGB(193, 60, 61, 60);
        forcastColor[1] = Color.fromARGB(193, 60, 61, 60);
        forcastColor[2] = Color.fromARGB(193, 60, 61, 60);
        forcastColor[3] = Color.fromARGB(193, 60, 61, 60);
        forcastColor[4] = Color.fromARGB(255, 60, 61, 60);
      }

      if(condition.toLowerCase().contains("rain")){
        bg = AssetImage("assets/rainyDayBG.png");
      }else if(condition.toLowerCase().contains("cloud")){
        bg = AssetImage("assets/cloudyBG.png");
      }else if(condition.toLowerCase().contains("clear") || condition.toLowerCase().contains("sunny") || condition.toLowerCase().contains("sun")){
        bg = AssetImage("assets/sunBG.png");
      }else if(condition.toLowerCase().contains("wind")){
        bg = AssetImage("assets/windyBG.png");
      }else if(condition.toLowerCase().contains("hot") || condition.toLowerCase().contains("temp")){
        bg = AssetImage("assets/hotBG.png");
      }else if(condition.toLowerCase().contains("snow") || condition.toLowerCase().contains("cold")){
        bg = AssetImage("assets/snowflakeBG.png");
      }else if(condition.toLowerCase().contains("drizzle")){
        bg = AssetImage("assets/rainyDayBG.png");
      }
    });
  }

  //to display popup
  placePopup(){
    errorMsg = '';
    showDialog(
      context: context, 
      builder: (context){
        return Localizations(
          delegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          locale: const Locale('en', 'US'),
          child: StatefulBuilder(
            builder: (context, setStateForDialog){
              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
                scrollable: true,
                backgroundColor: Color.fromARGB(193, 60, 61, 60),
                surfaceTintColor: Color.fromARGB(193, 60, 61, 60),
                shadowColor: Colors.grey,
                title: Text("Enter place Name/Zipcode", textAlign: TextAlign.center, style: TextStyle(
                  fontFamily: 'Baloo2',
                  color: Colors.white,
                ),),
                contentPadding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                content: Column(
                  children: [
                    SizedBox(
                      height: 45.0,
                      child: TextField(
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.white,
                        style: TextStyle(
                          fontFamily: 'Baloo2',
                          color: Colors.white,
                        ),
                        enableInteractiveSelection: true,
                        controller: textFieldController,
                        decoration: InputDecoration(
                          counterText: '',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: errorMsg == ''?false:true,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10.0,                          
                          ),
                          Text(errorMsg, style: TextStyle(color: Colors.red),),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(47, 48, 47, 0.911),
                        surfaceTintColor: Color.fromARGB(220, 102, 109, 102),
                        foregroundColor: Color.fromARGB(220, 102, 109, 102),
                        fixedSize: Size(
                          MediaQuery.of(context).size.width/1.6,
                          50,
                        ),
                        
                      ),
                      onPressed: (){
                        setStateForDialog(() {
                          if(textFieldController.text == ""){
                            errorMsg = "Please enter place or zipcode";
                          }else{
                            errorMsg = "";
                            setState(() {
                              placeInput = textFieldController.text;
                            });
                            fetchWeatherDetails(placeInput);
                            // Navigator.push(context, MaterialPageRoute(builder: (context){
                            //   return MainPage();
                            // }));
                            Navigator.pop(context);
                          }
                        });
                      },
                      child: Text("Get Weather", style: TextStyle(
                        fontFamily: 'Baloo2',
                        color: Colors.white,
                      ),),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                      }, 
                      child: Text("Cancel", style: TextStyle(
                        fontFamily: 'Baloo2',
                        color: Colors.white,
                      ),),
                    ),
                  ],
                ),
              );
            }
          ),
        );
    });
  }
}