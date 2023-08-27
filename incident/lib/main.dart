import 'package:flutter/material.dart';
import 'package:incident/listaIncidentes.dart';
import 'package:incident/criarIncidente.dart';
import 'package:incident/sidebarProfile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:latlong2/latlong.dart';
import 'firebase_options.dart';
import 'package:incident/login.dart';
import 'package:incident/mapaHome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

final List<LatLng> incidentLocations = [
  LatLng(-8.058488275256941, -34.92830895827107),
  LatLng(-8.05788189940112, -34.92422613999412)
];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const IncidentApp());
}

class IncidentApp extends StatelessWidget {
  const IncidentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(incidentLocations: incidentLocations),
        '/listaInfinita': (context) => ListaInfinitaTela(),
        '/login': (context) => LoginScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.orange[100],
        textTheme: TextTheme(
            labelLarge: TextStyle(
              fontSize: 26,
              fontFamily: 'Orienta',
            ),
            titleLarge: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              fontFamily: 'Bebes Neue',
            )),
        appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Colors.black),
            color: Colors.orange),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final List<LatLng> incidentLocations;

  MyHomePage({Key? key, required this.incidentLocations}) : super(key: key);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _doSomethingRequiringAuth(BuildContext context) {
    if (_auth.currentUser != null) {
      print('Ação realizada com sucesso!');
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var markers = incidentLocations.map((latlng) {
      return Marker(
        width: 80.0,
        height: 80.0,
        point: latlng,
        builder: (ctx) => GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
              content: Text(
                  "Latitude = ${latlng.latitude.toString()} :: Longitude = ${latlng.longitude.toString()}"),
            ));
          },
          child: Container(
            child: Icon(
              Icons.pin_drop,
              color: Colors.red,
            ),
          ),
        ),
      );
    }).toList();
    return Scaffold(
      backgroundColor: Colors.orange[100],
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          'CopWatch',
          style: TextStyle(
            fontSize: 26, // Change the font size
            fontFamily: 'Bebes Neue', // Change the font family
            fontWeight: FontWeight.bold, // Change the font weight
            color: Color.fromARGB(255, 0, 0, 0), // Change the text color
            fontStyle: FontStyle.normal, // Change the font style
          ),
        ),
      ),
      drawer: CustomDrawer(),
      body: FlutterMap(
        options: new MapOptions(
            center: new LatLng(-8.049898597727989, -34.904375418630245),
            zoom: 14.0),
        children: [
          TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
          MarkerLayer(markers: markers)
        ],
      ),
    );
  }
}
