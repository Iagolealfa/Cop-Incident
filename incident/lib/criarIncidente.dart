import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:incident/mapaCreate.dart';
import 'package:incident/login.dart';

class Incident {
  String titulo;
  String nome;
  int idade;
  bool isVisible;
  String genero;
  String raca;
  String descricao;
  LatLng localdoincidente;
  String usuario;

  Incident({
    required this.titulo,
    required this.nome,
    required this.idade,
    required this.isVisible,
    required this.genero,
    required this.raca,
    required this.descricao,
    required this.localdoincidente,
    required this.usuario,
  });
  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'nome': nome,
      'idade': idade,
      'isVisible': isVisible,
      'genero': genero,
      'raca': raca,
      'descricao': descricao,
      'latitude': localdoincidente.latitude,
      'longitude': localdoincidente.longitude,
      'usuario': usuario,
    };
  }

  factory Incident.fromJson(Map<String, dynamic> json) {
    return Incident(
      titulo: json['titulo'],
      nome: json['nome'],
      idade: json['idade'],
      isVisible: json['isVisible'],
      genero: json['genero'],
      raca: json['raca'],
      descricao: json['descricao'],
      localdoincidente: LatLng(json['latitude'], json['longitude']),
      usuario: json['usuario'],
    );
  }
}

class CreateIncidentModel {
  File _storedImage = File('assets/images/Incidentes.jpg');

  Future<void> takePictureFromG() async {
    final ImagePicker _picker = ImagePicker();
    XFile? imageFile = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (imageFile != null) {
      _storedImage = File(imageFile.path);
    } else {}
  }

  Future<void> takePhoto() async {
    final ImagePicker _picker = ImagePicker();
    XFile? imageFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (imageFile != null) {
      _storedImage = File(imageFile.path);
    } else {}
  }

  void storeIncidentInFirestore(Map<String, dynamic> incidentData) async {
    try {
      CollectionReference incidentsRef =
          FirebaseFirestore.instance.collection('incidents');

      await incidentsRef.add(incidentData);
    } catch (e) {}
  }
}

class CreateIncidentController {
  final CreateIncidentModel _model;

  CreateIncidentController(this._model);

  Future<void> createIncident(BuildContext context, Incident incident) async {
    final incidentJson = incident.toJson();
    _model.storeIncidentInFirestore(incidentJson);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ResponseScreen()),
    );
  }

  Future<void> takePictureFromG() async {
    await _model.takePictureFromG();
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
    isVisible: true,
    genero: 'Gênero',
    raca: 'Raça',
    descricao: '',
    localdoincidente: LatLng(0, 0),
    usuario: nomeUsuario,
  );
  TextEditingController salvaFormulario = TextEditingController(text: 'titulo');

  final _formKey = GlobalKey<FormState>();

  String? _validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório';
    }
    return null;
  }

  bool isValidRaca(String? value) {
    return value != 'Raça';
  }

  bool isValidGenero(String? value) {
    return value != 'Gênero';
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
                DropdownButton<String>(
                  value: _incident.raca,
                  onChanged: (newValue) {
                    setState(() {
                      _incident.raca = newValue ?? "Raça";
                    });
                  },
                  items: <String>['Raça', 'Branco', 'Preto', 'Pardo', 'Outro']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 25),
                DropdownButton<String>(
                  value: _incident.genero,
                  onChanged: (newValue) {
                    setState(() {
                      _incident.genero = newValue ?? "Prefiro Não Informar";
                    });
                  },
                  items: <String>[
                    'Gênero',
                    'Masculino',
                    'Feminino',
                    'Transgênero',
                    'Não Informar'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
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
                Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.location_on,
                      size: 50,
                    ),
                    onPressed: () async {
                      _incident.localdoincidente = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LocationSelectionScreen()),
                      );
                    },
                  ),
                ),
                SizedBox(height: 50),
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
                SizedBox(height: 50),
                Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.camera_alt_rounded,
                      size: 50,
                    ),
                    onPressed: () {
                      _controller.takePictureFromG();
                    },
                  ),
                ),
                SizedBox(height: 50),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if ((_formKey.currentState!.validate()) &&
                          isValidGenero(_incident.genero) &&
                          isValidRaca(_incident.raca)) {
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
              },
              child: Text('Voltar para Tela Inicial'),
            ),
          ],
        )));
  }
}
