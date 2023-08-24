import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CreateIncidentScreen extends StatefulWidget {
  @override
  _CreateIncidentScreenState createState() => _CreateIncidentScreenState();
}

class _CreateIncidentScreenState extends State<CreateIncidentScreen> {
  File _storedImage = File('assets/images/Incidentes.jpg');

  _takePicture() async {
    final ImagePicker _picker = ImagePicker();
    XFile imageFile = await _picker.pickImage(
      source: ImageSource.gallery,
    ) as XFile;

    setState(() {
      _storedImage = File(imageFile.path);
    });
  }

  _takePhoto() async {
    final ImagePicker _picker = ImagePicker();
    XFile imageFile = await _picker.pickImage(
      source: ImageSource.camera,
    ) as XFile;

    setState(() {
      _storedImage = File(imageFile.path);
    });
  }

  void _storeIncidentInFirestore(Incident incident) async {
    try {
      // Obtém uma referência para a coleção 'incidents'
      CollectionReference incidentsRef =
          FirebaseFirestore.instance.collection('incidents');

      // Adiciona um novo documento à coleção 'incidents' com os dados do incident
      await incidentsRef.add({
        'titulo': incident.titulo,
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
    titulo: '',
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
                  decoration: InputDecoration(hintText: 'Título'),
                  validator: _validateField,
                  onChanged: (value) {
                    setState(() {
                      _incident.titulo = value;
                    });
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Seu Nome'),
                  validator: _validateField,
                  onChanged: (value) {
                    setState(() {
                      _incident.nome = value;
                    });
                  },
                ),
                SizedBox(height: 25),
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
                SizedBox(height: 25),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Raça'),
                  validator: _validateField,
                  onChanged: (value) {
                    setState(() {
                      _incident.raca = value;
                    });
                  },
                ),
                SizedBox(height: 25),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Gênero'),
                  validator: _validateField,
                  onChanged: (value) {
                    setState(() {
                      _incident.genero = value;
                    });
                  },
                ),
                SizedBox(height: 25),
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
                SizedBox(height: 25),
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
                SizedBox(height: 5),
                Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.add_photo_alternate,
                      size: 50,
                    ),
                    onPressed: () {
                      _takePicture();
                    },
                  ),
                ),
                Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.camera_alt_rounded,
                      size: 50,
                    ),
                    onPressed: () {
                      _takePhoto();
                    },
                  ),
                ),
                SizedBox(height: 50),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Incident newIncident = Incident(
                          titulo: _incident.titulo,
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
  String titulo;
  String nome;
  int idade;
  String genero;
  String raca;
  String endereco;
  String descricao;

  Incident({
    required this.titulo,
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
        automaticallyImplyLeading: false,
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
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('Voltar para Tela Inicial'),
            ),
          ],
        ),
      ),
    );
  }
}
