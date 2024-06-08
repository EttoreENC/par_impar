import 'package:flutter/material.dart';

class Cadastro extends StatelessWidget {
  final Function(String) onRegister;

  Cadastro(this.onRegister);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final jogadorController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: jogadorController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Jogador",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do jogador';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Cadastrar'),
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    onRegister(jogadorController.text);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
