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
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('Incident Watch'),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/listaInfinita');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.orange, // Change the background color of the button
              foregroundColor:
                  Colors.black, // Change the text color of the button
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: Text('Incidentes'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.orange, // Change the background color of the button
              foregroundColor:
                  Colors.black, // Change the text color of the button
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: Text('Login'),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: Card(
                color: Colors.orange,
                elevation: 5,
                child: Text('Gráfico de calor dos incidentes')),
          ),
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
                    .orange[100], // Change the background color of the button
                foregroundColor:
                    Colors.black, // Change the text color of the button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              child: Text('Relatar Incidente')),
        ],
      ),
    );
  }
}
