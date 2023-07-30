import 'package:flutter/material.dart';
import 'package:incident/listaIncidentes.dart';
import 'package:incident/criarIncidente.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:incident/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const IncidentApp());
}
/*
class LoggedIn extends ChangeNotifier {
  bool isLoggedIn = false;
}*/

class IncidentApp extends StatelessWidget {
  const IncidentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
          // Change the text style for Buttons
          fontSize: 26, // Change the font size
          fontFamily: 'Orienta',
        )),
        appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Colors.black),
            color: Colors.orange),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //bool isLoggedIn = false; //Visibility attempt that didnt work

  void _doSomethingRequiringAuth(BuildContext context) {
    // Verifica se o usuário está autenticado
    if (_auth.currentUser != null) {
      // Se estiver autenticado, realiza a ação desejada
      print('Ação realizada com sucesso!');
    } else {
      // Se não estiver autenticado, redireciona para a tela de login
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
              fontSize: 34, // Change the font size
              fontFamily: 'Bebes Neue', // Change the font family
              fontWeight: FontWeight.bold, // Change the font weight
              color: Colors.white, // Change the text color
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
            ), /*
            Visibility(
                visible: !isLoggedIn,
                child: IconButton(
                  icon: Icon(Icons.login_rounded),
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                )),
            Visibility(
                visible: !isLoggedIn,
                child: IconButton(
                  icon: Icon(Icons.logout_rounded),
                  onPressed: () {
                    signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ))*/
            //will come back to this. Needs a builder for Streambuilder to work on the app bar.
          ],
        ),
        body: StreamBuilder<User?>(
            stream: _auth
                .authStateChanges(), // Stream to listen to authentication state changes
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                // Check if the user is logged in
                final isLoggedIn2 = snapshot.data != null;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Visibility(
                        visible: isLoggedIn2,
                        child: IconButton(
                          icon: Icon(Icons.logout_rounded),
                          onPressed: () {
                            signOut();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          },
                        )),
                    Visibility(
                        visible: !isLoggedIn2,
                        child: IconButton(
                          icon: Icon(Icons.login_rounded),
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                        )),
                    SizedBox(
                        width: double.infinity,
                        child: Image.asset('assets/images/Incidentes.jpg')),
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
                          backgroundColor: Colors
                              .orange, // Change the background color of the button
                          foregroundColor: Colors
                              .black, // Change the text color of the button
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
