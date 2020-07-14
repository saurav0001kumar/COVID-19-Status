import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

Future<Album> fetchAlbum() async {
  final response = await http.get('https://disease.sh/v3/covid-19/all');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  final int id;
  final int cases;
  final int todayCases;
  final int deaths;
  final int todayDeaths;
  final int recovered;
  final int todayRecovered;
  final int active;
  final int population;

  Album(
      {this.id,
      this.cases,
      this.todayCases,
      this.deaths,
      this.todayDeaths,
      this.recovered,
      this.todayRecovered,
      this.active,
      this.population});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      cases: json['cases'],
      todayCases: json['todayCases'],
      deaths: json['deaths'],
      todayDeaths: json['todayDeaths'],
      recovered: json['recovered'],
      todayRecovered: json['todayRecovered'],
      active: json['active'],
      population: json['population'],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

Future<Album2> fetchAlbum2(selectedCountry) async {
  final responses = await http
      .get('https://disease.sh/v3/covid-19/countries/${selectedCountry}');

  if (responses.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album2.fromJson(json.decode(responses.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album2 {
  final int id;
  final int cases;
  final int todayCases;
  final int deaths;
  final int todayDeaths;
  final int recovered;
  final int todayRecovered;
  final int active;
  final int population;
  final String country;
  final String flag;

  Album2(
      {this.id,
      this.cases,
      this.todayCases,
      this.deaths,
      this.todayDeaths,
      this.recovered,
      this.todayRecovered,
      this.active,
      this.population,
      this.country,
      this.flag});

  factory Album2.fromJson(Map<String, dynamic> json) {
    return Album2(
      id: json['id'],
      cases: json['cases'],
      todayCases: json['todayCases'],
      deaths: json['deaths'],
      todayDeaths: json['todayDeaths'],
      recovered: json['recovered'],
      todayRecovered: json['todayRecovered'],
      active: json['active'],
      population: json['population'],
      country: json['country'],
      flag: json['countryInfo']['flag'],
    );
  }
}

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.black,
  ));
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Covid-19 Status',
      theme: ThemeData(
        primaryColor: Colors.black,
        accentColor: Colors.amberAccent,
      ),
      home: MyApp()));
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var formKey1 = GlobalKey<FormState>();
  TextEditingController searchTC = TextEditingController();

  Future<Album> futureAlbum;
  Future<Album2> futureAlbum2;

  String selectedCountry;

  var cases;
  var todayCases;
  var deaths;
  var todayDeaths;
  var recovered;
  var todayRecovered;
  var active;
  var population;
  var drate;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _cases;
  var _todayCases;
  var _deaths;
  var _todayDeaths;
  var _recovered;
  var _todayRecovered;
  var _active;
  var _population;
  var _country;
  var _drate;
  var _flag;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerScrimColor: Colors.white24,
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: ListTile(
                  leading: img1(),
                  title: Text(
                    "COVID-19 Status",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white),
                  ),
                  subtitle: Text("Global COVID-19 Tracker",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white54)),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.developer_mode,
                color: Colors.black,
              ),
              trailing: Icon(
                Icons.android,
                color: Colors.greenAccent.shade700,
                size: 25,
              ),
              title: Text("Developer"),
              subtitle: Text(
                "Saurav Kumar",
                style: TextStyle(fontSize: 15),
              ),
            ),
            GestureDetector(
              onTap: _launchGithub,
              onLongPress: _launchGithub,
              child: ListTile(
                leading: github(),
                title: Text("GitHub"),
                subtitle: Text(
                  "View Source code",
                  style: TextStyle(fontSize: 15, color: Colors.blue),
                ),
              ),
            ),
            GestureDetector(
              onTap: _launchURL,
              onLongPress: _launchURL,
              child: ListTile(
                leading: Icon(
                  Icons.cloud,
                  color: Colors.black,
                ),
                title: Text("Data Source"),
                subtitle: Text(
                  "https://disease.sh/",
                  style: TextStyle(fontSize: 15, color: Colors.blue),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.help,
                color: Colors.black,
              ),
              title: Text("Help/Support E-mail"),
              subtitle: Text("sauravkumar.cse2018@nsec.ac.in"),
            ),
            ListTile(
              leading: Icon(
                Icons.info,
                color: Colors.black,
              ),
              title: Text("App Version"),
              subtitle: Text("Version 1.0.0"),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.reorder),
          color: Colors.white,
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        actions: [],
        elevation: 3,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
          "COVID-19 Status",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
          Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: img2(),
                fit: BoxFit.contain,
              )),
              padding: EdgeInsets.only(top: 35, bottom: 35),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "Global COVID-19 Status",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                  ),
                ],
              )),
          Container(
            child: FutureBuilder<Album>(
              future: futureAlbum,
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasData) {
                  cases = snapshot.data.cases;
                  todayCases = snapshot.data.todayCases;
                  deaths = snapshot.data.deaths;
                  todayDeaths = snapshot.data.todayDeaths;
                  recovered = snapshot.data.recovered;
                  todayRecovered = snapshot.data.todayRecovered;
                  active = snapshot.data.active;
                  population = snapshot.data.population;

                  return Column(
                    children: [
                      Container(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                      Container(
                          padding: EdgeInsets.only(
                              top: 0, bottom: 5, left: 10, right: 10),
                          child: Center(
                            child: Text(
                              "✪ Confirmed Cases: $cases  (⇡ +$todayCases)",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16),
                            ),
                          )),
                      Container(
                          padding: EdgeInsets.only(
                              top: 0, bottom: 5, left: 10, right: 10),
                          child: Center(
                            child: Text(
                              "✪ Active Cases: $active  (⇡ +$todayCases)",
                              style: TextStyle(
                                  color: Colors.amber.shade600,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16),
                            ),
                          )),
                      Container(
                          padding: EdgeInsets.only(
                              top: 0, bottom: 5, left: 10, right: 10),
                          child: Center(
                            child: Text(
                              "✪ Recovered: $recovered  (⇡ +$todayRecovered)",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16),
                            ),
                          )),
                      Container(
                          padding: EdgeInsets.only(
                              top: 0, bottom: 5, left: 10, right: 10),
                          child: Center(
                            child: Text(
                              "✪ Deaths: $deaths  (⇡ +$todayDeaths)",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16),
                            ),
                          )),
                    ],
                  );
                } else if (snapshot.hasError) {
                  debugPrint("${snapshot.error}");
                  return Column(
                    children: [
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Center(
                              child: Text(
                            "No Internet Connection.",
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ))),
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Center(
                              child: Text(
                            "Unable to load Global COVID-19 Status.",
                            style: TextStyle(
                                color: Colors.amber.shade600,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ))),
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Center(
                              child: FlatButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      futureAlbum = fetchAlbum();
                                      FutureBuilder<Album>(
                                          future: futureAlbum,
                                          builder:
                                              (BuildContext context, snapshot) {
                                            if (snapshot.hasData) {
                                              setState(() {
                                                cases = snapshot.data.cases;
                                                todayCases =
                                                    snapshot.data.todayCases;
                                                deaths = snapshot.data.deaths;
                                                todayDeaths =
                                                    snapshot.data.todayDeaths;
                                                recovered =
                                                    snapshot.data.recovered;
                                                todayRecovered = snapshot
                                                    .data.todayRecovered;
                                                active = snapshot.data.active;
                                                population =
                                                    snapshot.data.population;
                                                drate = snapshot.data.deaths /
                                                    snapshot.data.population;
                                                drate =
                                                    drate.toStringAsFixed(2);
                                              });
                                            }
                                          });
                                    });
                                  },
                                  icon: Icon(
                                    Icons.refresh,
                                    color: Colors.blue,
                                  ),
                                  label: Text(
                                    "Reload Status",
                                    style: TextStyle(
                                      color: Colors.blue,
                                    ),
                                  ))))
                    ],
                  );
                }

                return Column(
                  children: [
                    Container(
                        padding: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const SpinKitThreeBounce(color: Colors.blueAccent),
                            const SpinKitThreeBounce(color: Colors.amber),
                          ],
                        )),
                  ],
                );
              },
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: 10, bottom: 5), child: img3()),
          Container(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            child: Center(
              child: Text(
                "Check Country-Wise COVID-19 Status:",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
            child: Form(
              key: formKey1,
//            autovalidate: true,
              child: TextFormField(
//                scrollPadding : const EdgeInsets.all(5.0),
                textAlignVertical: TextAlignVertical.center,
                controller: searchTC,
                textCapitalization: TextCapitalization.characters,
                enableSuggestions: true,
//              autovalidate: true,
                validator: (String val) {
                  if (val.isEmpty) return ("Enter a Country to continue.");
                },
                textAlign: TextAlign.center,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.public, color: Colors.black),
                  suffixIcon:
                      Icon(Icons.arrow_forward_ios, color: Colors.black),
                  fillColor: Colors.yellowAccent,
                  hintText: "Enter a Country name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25)),
                ),
                enableInteractiveSelection: true,
              ),
            ),
          ),
          Container(
            height: 45,
            padding: EdgeInsets.only(left: 105, right: 105, bottom: 5),
            child: ButtonTheme(
              buttonColor: Colors.black,
              child: RaisedButton.icon(
                  elevation: 5,
                  onPressed: () {
                    selectedCountry = searchTC.text;

                    if (formKey1.currentState.validate()) {
                      futureAlbum2 = fetchAlbum2(selectedCountry);
                      print(selectedCountry);
                      getStatus(selectedCountry);
                    }
                  },
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 30,
                  ),
                  label: Text(
                    "Get Status",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  //img icon
  Widget img1() {
    var assetImage = AssetImage("assets/icon/icon.png");
    var image = Image(
      image: assetImage,
      height: 100,
      width: 100,
    );
    return Container(
      child: image,
//      alignment: Alignment.center,
      margin: EdgeInsets.all(0),
    );
  }

  ImageProvider img2() {
    var assetImage = AssetImage("assets/icon/global.png");
    var image = Image(
      image: assetImage,
      height: 105,
      width: 105,
    );
    return assetImage;
  }

  Widget img3() {
    var assetImage = AssetImage("assets/icon/img3.png");
    var image = Image(
      image: assetImage,
      height: 100,
      width: 100,
    );
    return Container(
      child: image,
//      alignment: Alignment.center,
      margin: EdgeInsets.all(0),
    );
  }

  Widget github() {
    var assetImage = AssetImage("assets/icon/github.png");
    var image = Image(
      image: assetImage,
      height: 25,
      width: 25,
    );
    return Container(
      child: image,
//      alignment: Alignment.center,
      margin: EdgeInsets.all(0),
    );
  }

  _launchURL() async {
    const url = 'https://disease.sh/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchGithub() async {
    const url = 'https://github.com/saurav0001kumar/COVID-19-Status';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void getStatus(selectedCountry) {
    AlertDialog alertDialog = AlertDialog(
      elevation: 10,
      backgroundColor: Color.fromARGB(255, 255, 234, 232),
      title: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: img2(),
            fit: BoxFit.contain,
          )),
          padding: EdgeInsets.only(top: 35, bottom: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "COVID-19 Status",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
            ],
          )),
      content: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
          Widget>[
        FutureBuilder<Album2>(
          future: futureAlbum2,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _cases = snapshot.data.cases;
              _todayCases = snapshot.data.todayCases;
              _deaths = snapshot.data.deaths;
              _todayDeaths = snapshot.data.todayDeaths;
              _recovered = snapshot.data.recovered;
              _todayRecovered = snapshot.data.todayRecovered;
              _active = snapshot.data.active;
              _population = snapshot.data.population;
              _country = snapshot.data.country;
              _flag = snapshot.data.flag;
              _drate = snapshot.data.deaths / snapshot.data.population;
              _drate = _drate.toStringAsFixed(2);
              _country = _country.toUpperCase();

              debugPrint("OK");
              return Column(
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Image(
                        image: NetworkImage(_flag),
                        height: 50,
                        width: 75,
                      )),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      "$_country",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  ),
                  Container(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
                  Container(
                      padding:
                          EdgeInsets.only(top: 0, bottom: 5, left: 5, right: 5),
                      child: Center(
                        child: Text(
                          "✪ Confirmed Cases ✪",
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      )),
                  Container(
                      padding:
                          EdgeInsets.only(top: 0, bottom: 5, left: 5, right: 5),
                      child: Center(
                        child: Text(
                          "$_cases  (⇡ +$_todayCases)",
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.normal,
                              fontSize: 16),
                        ),
                      )),
                  Container(
                      padding:
                          EdgeInsets.only(top: 0, bottom: 5, left: 5, right: 5),
                      child: Center(
                        child: Text(
                          "✪ Active Cases ✪",
                          style: TextStyle(
                              color: Colors.amber.shade600,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      )),
                  Container(
                      padding:
                          EdgeInsets.only(top: 0, bottom: 5, left: 5, right: 5),
                      child: Center(
                        child: Text(
                          "$_active  (⇡ +$_todayCases)",
                          style: TextStyle(
                              color: Colors.amber.shade600,
                              fontWeight: FontWeight.normal,
                              fontSize: 16),
                        ),
                      )),
                  Container(
                      padding:
                          EdgeInsets.only(top: 0, bottom: 5, left: 5, right: 5),
                      child: Center(
                        child: Text(
                          "✪ Recovered ✪",
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      )),
                  Container(
                      padding:
                          EdgeInsets.only(top: 0, bottom: 5, left: 5, right: 5),
                      child: Center(
                        child: Text(
                          "$_recovered  (⇡ +$_todayRecovered)",
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.normal,
                              fontSize: 16),
                        ),
                      )),
                  Container(
                      padding:
                          EdgeInsets.only(top: 0, bottom: 5, left: 5, right: 5),
                      child: Center(
                        child: Text(
                          "✪ Deaths ✪",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      )),
                  Container(
                      padding:
                          EdgeInsets.only(top: 0, bottom: 5, left: 5, right: 5),
                      child: Center(
                        child: Text(
                          "$_deaths  (⇡ +$_todayDeaths)",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.normal,
                              fontSize: 16),
                        ),
                      )),
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: RaisedButton.icon(
                        color: Colors.black,
                        icon: Icon(
                          Icons.highlight_off,
                          color: Colors.white,
                        ),
                        label: Text(
                          "CLOSE",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.pop(this.context);
                        },
                      )),
                ],
              );
            } else if (snapshot.hasError) {
              debugPrint("Network ERROR.");
              return Column(
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Icon(
                        Icons.report,
                        size: 70,
                        color: Colors.red,
                      )),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      "Unable to load COVID-19 status.",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.redAccent),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(bottom: 5, top: 10),
                      child: SpinKitRipple(
                        size: 65,
                        itemBuilder: (BuildContext context, int index) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index.isEven ? Colors.blue : Colors.amber,
                            ),
                          );
                        },
                      )),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Text(
                      "Possible Causes of ERROR",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade600),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Text(
                      "✔ No Internet Connection.",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.amber.shade600),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Text(
                      "✔ Invalid Country entered.",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.amber.shade600),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: RaisedButton.icon(
                        color: Colors.black,
                        icon: Icon(
                          Icons.highlight_off,
                          color: Colors.white,
                        ),
                        label: Text(
                          "CLOSE",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.pop(this.context);
                        },
                      )),
                ],
              );
            }

            // By default, show a loading spinner.
            return Column(
              children: [
                Container(
                    padding: EdgeInsets.only(bottom: 50),
                    child: SpinKitCubeGrid(
                      size: 65,
                      itemBuilder: (BuildContext context, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index.isEven ? Colors.blue : Colors.amber,
                          ),
                        );
                      },
                    )),
                Container(
                    padding: EdgeInsets.only(bottom: 50),
                    child: SpinKitHourGlass(
                      size: 40,
                      color: Colors.blue,
//                    itemBuilder: (BuildContext context, int index) {
//                      return DecoratedBox(
//                        decoration: BoxDecoration(
//                          shape: BoxShape.circle,
//                          color: index.isEven ? Colors.blue : Colors.amber,
//                        ),
//                      );
//                    },
                    ))
              ],
            );
          },
        ),
      ]),
    );
    showDialog(context: this.context, builder: (_) => alertDialog);
  }
}
