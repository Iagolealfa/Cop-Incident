import 'package:flutter/material.dart';
import 'package:incident/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateIncidentScreen extends StatefulWidget {
  @override
  _CreateIncidentScreenState createState() => _CreateIncidentScreenState();
}

class _CreateIncidentScreenState extends State<CreateIncidentScreen> {
  void _storeIncidentInFirestore(Incident incident) async {
    try {
      // Obtém uma referência para a coleção 'incidents'
      CollectionReference incidentsRef =
          FirebaseFirestore.instance.collection('incidents');

      // Adiciona um novo documento à coleção 'incidents' com os dados do incident
      await incidentsRef.add({
        'nome': incident.nome,
        'idade': incident.idade,
        'genero': incident.genero,
        'raca': incident.raca,
        'endereco': incident.endereco,
        'descricao': incident.descricao,
      });

      print('Incident armazenado com sucesso no Firestore!');
    } catch (e) {
      print('Erro ao armazenar o incident no Firestore: $e');
    }
  }

  Incident _incident = Incident(
    nome: '',
    idade: 0,
    genero: '',
    raca: '',
    endereco: '',
    descricao: '',
  );
  final _formKey = GlobalKey<FormState>();

  String? _validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Incidente'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(hintText: 'Seu Nome'),
                  validator: _validateField,
                  onChanged: (value) {
                    setState(() {
                      _incident.nome = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Idade'),
                  keyboardType: TextInputType.number,
                  validator: _validateField,
                  onChanged: (value) {
                    setState(() {
                      _incident.idade = int.tryParse(value) ?? 0;
                    });
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Raça'),
                  validator: _validateField,
                  onChanged: (value) {
                    setState(() {
                      _incident.raca = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Gênero'),
                  validator: _validateField,
                  onChanged: (value) {
                    setState(() {
                      _incident.genero = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration:
                      InputDecoration(hintText: 'Endereço do Incidente'),
                  validator: _validateField,
                  onChanged: (value) {
                    setState(() {
                      _incident.endereco = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration:
                      InputDecoration(hintText: 'Descrição do Incidente'),
                  validator: _validateField,
                  maxLength: 500,
                  maxLines: null,
                  onChanged: (value) {
                    setState(() {
                      _incident.descricao = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration:
                      InputDecoration(hintText: 'Adicionar Imagem ou Vídeo'),
                  onChanged: (value) {
                    setState(() {
                      _incident.endereco = value;
                    });
                  },
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Incident newIncident = Incident(
                        nome: _incident.nome,
                        idade: _incident.idade,
                        genero: _incident.genero,
                        raca: _incident.raca,
                        endereco: _incident.endereco,
                        descricao: _incident.descricao,
                      );

                      _storeIncidentInFirestore(newIncident);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResponseScreen()),
                      );
                    }
                  },
                  child: Text('Gerar Incidente'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Incident {
  String nome;
  int idade;
  String genero;
  String raca;
  String endereco;
  String descricao;

  Incident({
    required this.nome,
    required this.idade,
    required this.genero,
    required this.raca,
    required this.endereco,
    required this.descricao,
  });
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
