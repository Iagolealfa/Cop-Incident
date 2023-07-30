import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:incident/login.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _emailError;

  void _clearErrors() {
    setState(() {
      _emailError = null;
    });
  }

  Future<void> _sendPasswordResetEmail() async {
    _clearErrors();

    final String email = _emailController.text.trim();

    try {
      await _auth.sendPasswordResetEmail(email: email);
      // Caso a requisição seja bem-sucedida, exiba uma mensagem para o usuário
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Sucesso'),
          content: Text(
              'Um e-mail de recuperação de senha foi enviado para $email.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              child: Text('Fechar'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (e is FirebaseAuthException) {
        setState(() {
          if (e.code == 'user-not-found') {
            _emailError =
                "Não foi possível encontrar um usuário com esse e-mail.";
          } else {
            _emailError =
                "Erro ao enviar o e-mail de recuperação de senha: ${e.message}";
          }
        });
      } else {
        setState(() {
          _emailError = "Erro ao enviar o e-mail de recuperação de senha: $e";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperação de Senha'),
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
                labelText: 'E-mail',
                errorText: _emailError,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _sendPasswordResetEmail,
              child: Text('Enviar E-mail de Recuperação de Senha'),
            ),
          ],
        ),
      ),
    );
  }
}
