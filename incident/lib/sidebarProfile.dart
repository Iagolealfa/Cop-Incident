import 'package:flutter/material.dart';
import 'package:incident/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(nomeUsuario),
            accountEmail: Text('$emailUsuario'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.orange[100],
              child: Icon(Icons.person),
            ),
          ),
          ListTile(
            leading: Icon(Icons.format_list_bulleted),
            title: Text('Meus Incidentes'),
            onTap: () {
                Navigator.pushNamed(context, '/listaInfinita');
            },
          ),
          // Add more list items as needed
        ],
      ),
    );
  }
}
