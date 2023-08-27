import 'package:flutter/material.dart';
import 'package:incident/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:incident/criarIncidente.dart';

class CustomDrawer extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      print('Usuário deslogado com sucesso!');
    } catch (e) {
      print('Erro ao deslogar o usuário: $e');
    }
  }

  void _doSomethingRequiringAuth(BuildContext context) {
    if (_auth.currentUser != null) {
      print('Ação realizada com sucesso!');
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    }
  }

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
            leading: Icon(Icons.login_rounded),
            title: Text('Login'),
            onTap: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
          ListTile(
            leading: Icon(Icons.format_list_bulleted),
            title: Text('Criar Incidente'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateIncidentScreen()),
              );
              _doSomethingRequiringAuth(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.format_list_bulleted),
            title: Text('Meus Incidentes'),
            onTap: () {
              Navigator.pushNamed(context, '/listaInfinita');
              _doSomethingRequiringAuth(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.login_rounded),
            title: Text('Logout'),
            onTap: () {
              signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
