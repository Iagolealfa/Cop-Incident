import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CreateIncidentModel {
  File _storedImage = File('assets/images/Incidentes.jpg');

  Future<void> takePicture() async {
    final ImagePicker _picker = ImagePicker();
    XFile? imageFile = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (imageFile != null) {
      _storedImage = File(imageFile.path);
    } else {
      print("Nenhuma imagem selecionada");
    }
  }

  Future<void> takePhoto() async {
    final ImagePicker _picker = ImagePicker();
    XFile? imageFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (imageFile != null) {
      _storedImage = File(imageFile.path);
    } else {
      print("Nenhuma imagem selecionada");
    }
  }

  void storeIncidentInFirestore(Incident incident) async {
    try {
      CollectionReference incidentsRef =
          FirebaseFirestore.instance.collection('incidents');

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
}

class CreateIncidentController {
  final CreateIncidentModel _model;

  CreateIncidentController(this._model);

  Future<void> createIncident(BuildContext context, Incident incident) async {
    _model.storeIncidentInFirestore(incident);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ResponseScreen()),
    );
  }

  Future<void> takePicture() async {
    await _model.takePicture();
  }

  Future<void> takePhoto() async {
    await _model.takePhoto();
  }
}

class CreateIncidentScreen extends StatefulWidget {
  @override
  _CreateIncidentScreenState createState() => _CreateIncidentScreenState();
}

class _CreateIncidentScreenState extends State<CreateIncidentScreen> {
  CreateIncidentModel _model = CreateIncidentModel();
  late CreateIncidentController _controller;

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
  void initState() {
    super.initState();
    _controller = CreateIncidentController(_model);
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
                SizedBox(height: 25),
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
                      _controller.takePhoto();
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
                      _controller.takePicture();
                    },
                  ),
                ),
                SizedBox(height: 50),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _controller.createIncident(context, _incident);
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
        )));
  }
}
