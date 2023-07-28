import 'package:flutter/material.dart';
import 'package:incident/listaIncidentes.dart';
import 'package:incident/criarIncidente.dart';

void main() {
  runApp(const IncidentApp());
}

class IncidentApp extends StatelessWidget {
  const IncidentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        '/listaInfinita': (context) => ListaInfinitaTela(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

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
                  },
                  child: Text('Criar Incidente'))),
          Card(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/listaInfinita');
              },
              child: Text('Lista de Incidentes'),
            ),
          ),
        ],
      ),
    );
  }
}
