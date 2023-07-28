import 'package:flutter/material.dart';
import 'package:incident/main.dart';

class CreateIncidentScreen extends StatefulWidget {
  @override
  _CreateIncidentScreenState createState() => _CreateIncidentScreenState();
}

class _CreateIncidentScreenState extends State<CreateIncidentScreen> {
  String? nome = '';
  int idade = 0;
  String? genero = '';
  String? raca = '';
  String? endereco = '';
  String? descricao = '';
  final _formKey = GlobalKey<FormState>();

  String? _validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório';
    }
    return null;
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(hintText: 'Seu Nome'),
                  validator: _validateField,
                  onChanged: (value) {
                    setState(() {
                      nome = value;
                    });
                  },
                ),
                SizedBox(height: 24),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Sua Idade'),
                  keyboardType: TextInputType.number,
                  validator: _validateField,
                  onChanged: (value) {
                    setState(() {
                      idade = int.tryParse(value) ?? 0;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Sua Raça'),
                  validator: _validateField,
                  onChanged: (value) {
                    setState(() {
                      raca = value;
                    });
                  },
                ),
                SizedBox(height: 24),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Seu Gênero'),
                  validator: _validateField,
                  onChanged: (value) {
                    setState(() {
                      genero = value;
                    });
                  },
                ),
                SizedBox(height: 24),
                TextFormField(
                  decoration:
                      InputDecoration(hintText: 'Endereço do Incidente'),
                  validator: _validateField,
                  onChanged: (value) {
                    setState(() {
                      endereco = value;
                    });
                  },
                ),
                SizedBox(height: 24),
                TextFormField(
                  decoration:
                      InputDecoration(hintText: 'Descrição do Incidente'),
                  validator: _validateField,
                  maxLines: null,
                  onChanged: (value) {
                    setState(() {
                      descricao = value;
                    });
                  },
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Implemente aqui a lógica para submeter os dados do formulário.
                      // Por exemplo, enviar os dados para um servidor ou salvá-los localmente.
                      // Para esta demonstração, apenas exibiremos os dados no console.
                      print('Nome: $nome');
                      print('Idade: $idade');
                      print('Raça: $raca');
                      print('Gênero: $genero');
                      print('Endereço: $endereco');
                      print('Descrição: $descricao');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResponseScreen()),
                      );
                    }
                  },
                  child: Text('Gerar Incidente'),
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
        automaticallyImplyLeading:
            false, // Remover o botão de voltar padrão da App Bar
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
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => MyHomePage()));
              },
              child: Text('Voltar para Tela Inicial'),
            ),
          ],
        ),
      ),
    );
  }
}
