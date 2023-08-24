import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:incident/main.dart';
import 'package:incident/criarConta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:incident/recuperarSenha.dart';

class LoginModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential?> login(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return null;
      }

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    } catch (e) {
      return null;
    }
  }

  Future<String?> getUserName(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      String? userName = userDoc.get('usuario');
      return userName;
    } catch (e) {
      return null;
    }
  }
}

class LoginController {
  final LoginModel _model;

  LoginController(this._model);

  Future<void> login(
      BuildContext context, String email, String password) async {
    UserCredential? userCredential = await _model.login(email, password);

    if (userCredential != null) {
      String? userName = await _model.getUserName(userCredential.user!.uid);
      if (userName != null) {
        print('Usuário logado: ${userCredential.user!.email}');
        print('Nome do usuário: $userName');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Erro'),
            content: Text('Erro ao obter o nome do usuário.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Ok'),
              ),
            ],
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erro'),
          content: Text('Login ou senha incorretos.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Ok'),
            ),
          ],
        ),
      );
    }
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginModel _model = LoginModel();
  late final LoginController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LoginController(_model);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login'), automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'CopWatch',
              style: TextStyle(
                fontSize: 34,
                fontFamily: 'Bebes Neue',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 100),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _controller.login(
                  context,
                  _emailController.text,
                  _passwordController.text,
                );
              },
              child: Text('Entrar'),
            ),
            SizedBox(height: 12),
            TextButton(
              onPressed: () {
                // Navegar para a tela de criação de nova conta
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateAccountScreen(),
                  ),
                );
              },
              child: Text('Criar Nova Conta'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ForgotPasswordScreen(),
                  ),
                );
              },
              child: Text('Esqueci minha senha'),
            ),
          ],
        ),
      ),
    );
  }
}
