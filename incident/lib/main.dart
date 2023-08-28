import 'package:flutter/material.dart';
import 'package:incident/listaIncidentes.dart';
import 'package:incident/sidebarProfile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:latlong2/latlong.dart';
import 'firebase_options.dart';
import 'package:incident/login.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class IncidentLocationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<LatLng>> fetchIncidentLocations() async {
    QuerySnapshot snapshot = await _firestore.collection('incidents').get();

    List<LatLng> locations = snapshot.docs.map((DocumentSnapshot document) {
      double latitude = document['latitude'];
      double longitude = document['longitude'];
      return LatLng(latitude, longitude);
    }).toList();

    return locations;
  }
}

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
        '/': (context) => MyHomePage(),
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

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final IncidentLocationService _locationService = IncidentLocationService();
  List<LatLng> incidentLocations = [];
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    fetchIncidentLocations();

    _timer = Timer.periodic(Duration(minutes: 1), (Timer t) {
      fetchIncidentLocations();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void fetchIncidentLocations() async {
    List<LatLng> locations = await _locationService.fetchIncidentLocations();

    setState(() {
      incidentLocations = locations;
    });
  }

  @override
  Widget build(BuildContext context) {
    var markers = incidentLocations.map((latlng) {
      return Marker(
        width: 30.0,
        height: 30.0,
        point: latlng,
        builder: (ctx) => GestureDetector(
          onTap: () {
            // ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
            //   content: Text(
            //       "Latitude = ${latlng.latitude.toString()} :: Longitude = ${latlng.longitude.toString()}"),
            // ));
          },
          child: Container(
            child: Icon(
              Icons.warning,
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
            fontSize: 26,
            fontFamily: 'Bebes Neue',
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
      drawer: CustomDrawer(),
      body: FlutterMap(
        options: new MapOptions(
            center: new LatLng(-8.049898597727989, -34.904375418630245),
            zoom: 13.0),
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
