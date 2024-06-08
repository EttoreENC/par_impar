import 'package:flutter/material.dart';

class Aposta extends StatefulWidget {
  final Function callback;
  final Map<String, dynamic> jogador;
  final Function realizarAposta;

  Aposta(this.callback, this.jogador, this.realizarAposta);

  @override
  State<StatefulWidget> createState() => _ApostaState();
}

class _ApostaState extends State<Aposta> {
  int dedos = 1;
  int valorAposta = 0;
  int parImpar = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aposta ${widget.jogador['nome']}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Escolha o número (1-5)"),
            Slider(
              label: "$dedos",
              min: 1,
              divisions: 5,
              max: 5,
              value: dedos.toDouble(),
              onChanged: (val) {
                setState(() {
                  dedos = val.toInt();
                });
              },
            ),
            const SizedBox(height: 20),
            const Text("Valor da aposta"),
            Slider(
              label: "$valorAposta",
              min: 0,
              divisions: 10,
              max: 100,
              value: valorAposta.toDouble(),
              onChanged: (val) {
                setState(() {
                  valorAposta = val.toInt();
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio(
                  value: 2,
                  groupValue: parImpar,
                  onChanged: (int? value) {
                    setState(() {
                      parImpar = value!;
                    });
                  },
                ),
                const Text('Par'),
                Radio(
                  value: 1,
                  groupValue: parImpar,
                  onChanged: (int? value) {
                    setState(() {
                      parImpar = value!;
                    });
                  },
                ),
                const Text('Ímpar'),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Escolher Adversário'),
              onPressed: () {
                widget.realizarAposta(widget.jogador['nome'], valorAposta, parImpar, dedos);
              },
            ),
          ],
        ),
      ),
    );
  }
}
