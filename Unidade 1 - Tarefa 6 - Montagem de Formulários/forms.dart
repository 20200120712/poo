import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exemplo de Formulário',
      home: PaginaFormulario(),
    );
  }
}

class PaginaFormulario extends StatefulWidget {
  @override
  _PaginaFormularioState createState() => _PaginaFormularioState();
}

class _PaginaFormularioState extends State<PaginaFormulario> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _idadeController = TextEditingController();

  String _genero = 'Feminino';
  String _gosto = 'Filmes';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe o seu nome.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe o seu e-mail.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _idadeController,
                decoration: InputDecoration(
                  labelText: 'Idade',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe a sua idade.';
                  }
                  return null;
                },
              ),
              Text('Gênero'),
              RadioListTile<String>(
                title: Text('Feminino'),
                value: 'Feminino',
                groupValue: _genero,
                onChanged: (value) {
                  setState(() {
                    _genero = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: Text('Masculino'),
                value: 'Masculino',
                groupValue: _genero,
                onChanged: (value) {
                  setState(() {
                    _genero = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: Text('Outro'),
                value: 'Outro',
                groupValue: _genero,
                onChanged: (value) {
                  setState(() {
                    _genero = value!;
                  });
                },
              ),
              Text('Gosto por filmes, séries ou desenhos'),
              RadioListTile<String>(
                title: Text('Filmes'),
                value: 'Filmes',
                groupValue: _gosto,
                onChanged: (value) {
                  setState(() {
                    _gosto = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: Text('Séries'),
                value: 'Séries',
                groupValue: _gosto,
                onChanged: (value) {
                  setState(() {
                    _gosto = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: Text('Desenhos'),
                value: 'Desenhos',
                groupValue: _gosto,
                onChanged: (value) {
                  setState(() {
                    _gosto = value!;
                  });
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Formulário está sendo processado...'),
                      ),
                    );
                  }
                },
                child: Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
