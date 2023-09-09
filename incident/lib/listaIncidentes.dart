import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:incident/editarIncidente.dart';
import 'package:incident/criarIncidente.dart';
import 'package:incident/login.dart';

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
    _incidentsStream = FirebaseFirestore.instance
        .collection('incidents')
        .where('isVisible', isEqualTo: true)
        .where('usuario', isEqualTo: nomeUsuario)
        .snapshots();
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
                final incidentData =
                    incidents[index].data() as Map<String, dynamic>;
                final incidentId = incidents[index].id;

                final incident = Incident.fromJson(incidentData);

                return Dismissible(
                  key: Key(incidentId),
                  direction: DismissDirection.horizontal,
                  onDismissed: (direction) async {
                    await FirebaseFirestore.instance
                        .collection('incidents')
                        .doc(incidentId)
                        .update({'isVisible': false});

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Item removido: $incidentId'),
                        action: SnackBarAction(
                          label: 'Desfazer',
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('incidents')
                                .doc(incidentId)
                                .update({'isVisible': true});
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
                    title: Text(incident.titulo),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditarItemTela(
                              itemId: incidentId, itemData: incidentData),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ));
  }
}
