import 'package:flutter/material.dart';
import 'package:incident/listaIncidentes.dart';
import 'package:incident/criarIncidente.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:latlong2/latlong.dart';
import 'firebase_options.dart';
import 'package:incident/login.dart';
import 'package:incident/mapaHome.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

class MyHomePage extends StatelessWidget {
  final List<LatLng> incidentLocations = [
    LatLng(-8.058488275256941, -34.92830895827107),
    LatLng(-8.05788189940112, -34.92422613999412)
  ];

  MyHomePage({super.key});
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

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      print('Usuário deslogado com sucesso!');
    } catch (e) {
      print('Erro ao deslogar o usuário: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons
                  .list_alt_rounded), // Icon as an action button on the app bar
              onPressed: () {
                Navigator.pushNamed(context, '/listaInfinita');
                _doSomethingRequiringAuth(context);
              },
            ),
            Visibility(
                visible: true,
                child: IconButton(
                  icon: Icon(Icons.login_rounded),
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                )),
            Visibility(
                visible: true,
                child: IconButton(
                  icon: Icon(Icons.logout_rounded),
                  onPressed: () {
                    signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ))
          ],
        ),
        body: StreamBuilder<User?>(
            stream: _auth.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Map(incidentLocations)),
                          );
                          _doSomethingRequiringAuth(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                        ),
                        child: Text(
                          'Mapa de calor',
                        )),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateIncidentScreen()),
                          );
                          _doSomethingRequiringAuth(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                        ),
                        child: Text(
                          'Criar Incidente',
                        )),
                  ],
                );
              }
            }));
  }
}
