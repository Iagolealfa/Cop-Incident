import 'package:flutter/material.dart';

void main() {
  runApp(const IncidentApp());
}

class IncidentApp extends StatelessWidget {
  const IncidentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyHomePage());
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
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            width: double.infinity,
            child: const Card(
              color: Colors.blue,
              child: Text('Gráfico de calor dos incidentes'),
              elevation: 5,
            ),
          ),
          const Card(
            child: Text('Botão para criação de incidente'),
          ),
        ],
      ),
    );
  }
}
