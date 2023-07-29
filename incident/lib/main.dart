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
      appBar: AppBar(
        title: const Text('Incident Watch'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: double.infinity,
            child: Card(
                color: Colors.blue,
                elevation: 5,
                child: Text('Gráfico de calor dos incidentes')),
          ),
          Card(
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateIncidentScreen()),
                    );
                    _doSomethingRequiringAuth(context);
                  },
                  child: Text('Criar Incidente'))),
          Card(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/listaInfinita');
                _doSomethingRequiringAuth(context);
              },
              child: Text('Lista de Incidentes'),
            ),
          ),
          Card(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text('LOGIN'),
            ),
          ),
        ],
      ),
    );
  }
}
