import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditarItemTela extends StatefulWidget {
  final String itemId;
  final Map<String, dynamic> itemData;

  EditarItemTela({required this.itemId, required this.itemData});

  @override
  _EditarItemTelaState createState() => _EditarItemTelaState();
}

class _EditarItemTelaState extends State<EditarItemTela> {
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
 

  @override
  void initState() {
    super.initState();
    _tituloController.text = widget.itemData['titulo'];
    _descricaoController.text = widget.itemData['descricao'];

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Item'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _tituloController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            TextFormField(
              controller: _descricaoController,
              decoration: InputDecoration(labelText: 'Descrição'),
            ),

            ElevatedButton(
              onPressed: () {
                _salvarAlteracoes();
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  void _salvarAlteracoes() async {
    final novoTitulo = _tituloController.text;
    final novaDescricao = _descricaoController.text;


    await FirebaseFirestore.instance
        .collection('incidents')
        .doc(widget.itemId)
        .update({
      'title': novoTitulo,
      'descricao': novaDescricao,

    });

    Navigator.pop(context);
  }
}
