import 'package:flutter/material.dart';
import 'package:incident/listaIncidentes.dart';


void main() {
  runApp(const IncidentApp());
}

class IncidentApp extends StatelessWidget {
  const IncidentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      initialRoute: '/', 
      routes: {
      '/' : (context) => const MyHomePage(),
      '/listaInfinita' :(context) => ListaInfinitaTela(),
    } ,);
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
                Navigator.pushNamed(context,'/listaInfinita');
              },
              child: Text('Lista de Incidentes'),
            ),
          ),        
        ],
      ),
    );
  }
}

class CreateIncidentScreen extends StatefulWidget {
  @override
  _CreateIncidentScreenState createState() => _CreateIncidentScreenState();
}

class _CreateIncidentScreenState extends State<CreateIncidentScreen> {
  String nome = '';
  int idade = 0;
  String genero = '';
  String raca = '';
  String endereco = '';
  String descricao = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Incidente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(hintText: 'Seu Nome'),
              onChanged: (value) {
                setState(() {
                  nome = value;
                });
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(hintText: 'Sua Idade'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  idade = int.tryParse(value) ?? 0;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(hintText: 'Sua Raça'),
              onChanged: (value) {
                setState(() {
                  raca = value;
                });
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(hintText: 'Seu Gênero'),
              onChanged: (value) {
                setState(() {
                  genero = value;
                });
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(hintText: 'Endereço do Incidente'),
              onChanged: (value) {
                setState(() {
                  endereco = value;
                });
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(hintText: 'Descrição do Incidente'),
              onChanged: (value) {
                setState(() {
                  descricao = value;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implemente aqui a lógica para submeter os dados do formulário.
                // Por exemplo, enviar os dados para um servidor ou salvá-los localmente.
                // Para esta demonstração, apenas exibiremos os dados no console.
                print('Nome: $nome');
                print('Idade: $idade');
                print('Raça: $raca');
                print('Gênero: $genero');
                print('Endereço: $endereco');
                print('Descrição: $descricao');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResponseScreen()),
                );
              },
              child: Text('Comitar Incidente'),
            ),
          ],
        ),
      ),
    );
  }
}

class ResponseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:
            false, // Remover o botão de voltar padrão da App Bar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Incidente criado com sucesso!',
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => MyHomePage()));
              },
              child: Text('Voltar para Tela Inicial'),
            ),
          ],
        ),
      ),
    );
  }
}