import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListaInfinitaTela extends StatefulWidget {
  @override
  _ListaInfinitaTelaState createState() => _ListaInfinitaTelaState();
}

class _ListaInfinitaTelaState extends State<ListaInfinitaTela> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _incidentsStream;

  @override
  void initState() {
    super.initState();
    _buscarIncidents();
  }

  void _buscarIncidents() {
    _incidentsStream = FirebaseFirestore.instance.collection('incidents').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista Incidentes'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _incidentsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Erro: ${snapshot.error}');
          }

          final List<QueryDocumentSnapshot> incidents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: incidents.length,
            itemBuilder: (context, index) {
              final item = incidents[index].data();
              final itemId = incidents[index].id;
              return Dismissible(
                key: Key(itemId),
                direction: DismissDirection.horizontal,
                onDismissed: (direction) async {
                  // Remove o item do Firestore
                  await FirebaseFirestore.instance.collection('incidents').doc(itemId).delete();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Item removido: $itemId'),
                      action: SnackBarAction(
                        label: 'Desfazer',
                        onPressed: () async {
                          // Re-adiciona o item ao Firestore
                          final Map<String, dynamic> itemMap = item as Map<String, dynamic>;
                          await FirebaseFirestore.instance.collection('incidents').doc(itemId).set(itemMap);
                        },
                      ),
                    ),
                  );
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                 child: ListTile(
                  title: Text( '$itemId'),
                  // Adicione outros widgets relevantes para exibir outros dados do documento
                ),
              );
            },
          );
        },
      ),
    );
  }
}
