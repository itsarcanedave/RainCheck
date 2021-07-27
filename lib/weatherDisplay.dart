import 'package:flutter/material.dart';
import 'constants.dart';
import 'getWeather.dart';
import 'search.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key, this.locationWeather}) : super(key: key);

  final locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weatherModel = WeatherModel();
  String? cityName;
  int? currentTemp;
  String? weatherMessage;
  String? inputValue;
  String? icon;
  String? desc;



  @override
  void initState() {
    updateUI(widget.locationWeather);
    super.initState();
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    var networkData = await weatherModel.getLocationWeather();
    updateUI(networkData);
    if(mounted)
      setState(() {

      });
    _refreshController.loadComplete();
  }

  void updateUI(dynamic data) {
    setState(() {
      cityName = data['name'];
      double tempDouble = data['main']['temp'];
      currentTemp = tempDouble.round().toInt();
      var currentCondition = data['weather'][0]['id'];
      //weatherIcon = weatherModel.getWeatherIcon(currentCondition);
      var weatherIcon = data['weather'][0]['icon'];
      icon = weatherIcon.toString();
      var weatherDesc = data['weather'][0]['description'];
      desc = weatherDesc;
      desc = capitalize(desc!);



    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
          child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/colorbg2.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),

        constraints: BoxConstraints.expand(),
        child: SafeArea(

          child: Column(

            children: <Widget>[
              Row(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[

                  TextButton(
                    onPressed: () async {
                      var networkData = await weatherModel.getLocationWeather();
                      updateUI(networkData);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      var typedName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CityScreen();
                          },
                        ),
                      );
                      if (typedName != null) {
                        var networkData = await weatherModel.getCityWeather(typedName);
                        updateUI(networkData);
                      }
                    },
                    child: Icon(
                      Icons.search,
                      size: 50.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20.0),
              ),
              Text(
                "$cityName",
                textAlign: TextAlign.center,
                style:  GoogleFonts.getFont('Raleway', fontSize: 40, fontWeight: FontWeight.w600,),
              ),
          Padding(
            padding: EdgeInsets.only(bottom: 30.0),
          ),
              Image.network('http://openweathermap.org/img/wn/$icon@4x.png'),
              Text(
                desc!,
                textAlign: TextAlign.center,
                style:  GoogleFonts.getFont('Raleway', fontSize: 25, fontWeight: FontWeight.bold,),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 50.0),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 25.0),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      '$currentTemp°C',
                      textAlign: TextAlign.center,
                      style:  GoogleFonts.getFont('Overpass', fontSize: 90, fontWeight: FontWeight.w600,),
                    ),

                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 60.0),

              ),
              Text(
                "RainCheck - a simple weather application",
                textAlign: TextAlign.center,
                style:  GoogleFonts.getFont('Raleway', fontSize: 15, fontWeight: FontWeight.w300,),
              ),
              Text(
                "A project by ArcaneDave",
                textAlign: TextAlign.center,
                style:  GoogleFonts.getFont('Raleway', fontSize: 15, fontWeight: FontWeight.w300,),
              ),

            ],
          ),
        ),
      ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
      ),

    );
  }
}
