import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:incident/login.dart';
import 'package:incident/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateAccountModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential?> createAccount(
      String email, String password, String usuario) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'usuario': usuario,
      });

      return userCredential;
    } catch (e) {
      return null;
    }
  }
}

class CreateAccountController {
  final CreateAccountModel _model;

  CreateAccountController(this._model);

  Future<void> createAccount(BuildContext context, String email,
      String password, String confirmPassword, String usuario) async {
    UserCredential? userCredential =
        await _model.createAccount(email, password, usuario);

    if (userCredential != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MyHomePage(incidentLocations: incidentLocations),
        ),
      );
    } else {
      // Tratar erros ao criar conta
    }
  }
}

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _usuarioController = TextEditingController();
  final CreateAccountModel _model = CreateAccountModel();
  late final CreateAccountController _controller;

  String? _emailError;
  String? _passwordError;

  void _clearErrors() {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = CreateAccountController(_model);
  }

  Future<void> _createAccount() async {
    _clearErrors();

    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();
    final String usuario = _usuarioController.text.trim();

    if (email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        usuario.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erro'),
          content: Text('É obrigatório preencher todos os campos.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Ok'),
            ),
          ],
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _passwordError = "Senhas não conferem.";
      });
      return;
    }
    emailUsuario = email;
    nomeUsuario = usuario;
    _controller.createAccount(
        context, email, password, confirmPassword, usuario);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Nova Conta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usuarioController,
              decoration: InputDecoration(
                labelText: 'Usuário',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: _emailError,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                errorText: _passwordError,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirme a Senha',
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _createAccount,
              child: Text('Criar Conta'),
            ),
          ],
        ),
      ),
    );
  }
}
