import 'package:flutter/material.dart';

class Resultado extends StatefulWidget {
  final Function(int) callback;
  final Map<String, dynamic> jogadorAtual;
  final Map<String, dynamic> oponente;
  final Future<Map<String, dynamic>> Function(String, String) jogar;

  Resultado(this.callback, this.jogadorAtual, this.oponente, this.jogar);

  @override
  _ResultadoState createState() => _ResultadoState();
}

class _ResultadoState extends State<Resultado> {
  bool jogoExecutado = false;
  String vencedor = '';
  int pontosJogadorAtual = 0;
  String mensagem = '';

  @override
  void initState() {
    super.initState();
    pontosJogadorAtual = widget.jogadorAtual['pontos'];
  }

  void executarJogo() async {
    try {
      final resultado = await widget.jogar(widget.jogadorAtual['nome'], widget.oponente['username']);
      setState(() {
        jogoExecutado = true;
        if (resultado.containsKey('msg') && resultado['msg'] == 'Ninguem ganhou!') {
          mensagem = 'Ninguém ganhou!';
        } else {
          vencedor = resultado['vencedor']['username'];
          pontosJogadorAtual = widget.jogadorAtual['pontos'];
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao executar o jogo: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Jogador Atual: ${widget.jogadorAtual['nome']}'),
            Text('Oponente: ${widget.oponente['username'] ?? 'Oponente não selecionado'}'),
            if (jogoExecutado) ...[
              if (mensagem.isNotEmpty)
                Text(mensagem)
              else ...[
                Text('Vencedor: $vencedor'),
                Text('Pontuação Atual: $pontosJogadorAtual'),
              ],
            ] else ...[
              ElevatedButton(
                child: const Text('Iniciar Jogo'),
                onPressed: executarJogo,
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Nova Aposta'),
              onPressed: () => widget.callback(1),
            ),
          ],
        ),
      ),
    );
  }
}
