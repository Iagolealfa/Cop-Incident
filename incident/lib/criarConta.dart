import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:incident/main.dart';

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _emailError;
  String? _passwordError;

  void _clearErrors() {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });
  }

  Future<void> _createAccount() async {
    _clearErrors();

    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      // Verifica se os campos estão vazios
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _passwordError = "Senhas não conferem.";
      });
      return;
    }

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Sucesso! Nova conta criada e o usuário está logado.
      print('Nova conta criada: ${userCredential.user?.email}');

      // Após a criação da nova conta bem-sucedida, navegar para a tela HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(),
        ),
      );
    } catch (e) {
      if (e is FirebaseAuthException) {
        setState(() {
          if (e.code == 'email-already-in-use') {
            _emailError = "O e-mail já está em uso por outra conta.";
          } else {
            _emailError = "Erro ao criar nova conta: ${e.message}";
          }
        });
      } else {
        setState(() {
          _emailError = "Erro ao criar nova conta: $e";
        });
      }
    }
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
