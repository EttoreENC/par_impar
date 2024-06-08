import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:par_impar/aposta.dart';
import 'package:par_impar/cadastro.dart';
import 'package:par_impar/lista.dart';
import 'package:par_impar/resultado.dart';

void main() {
  runApp(ParImparApp());
}

class ParImparApp extends StatefulWidget {
  @override
  _ParImparAppState createState() => _ParImparAppState();
}

class _ParImparAppState extends State<ParImparApp> {
  int currentScreen = 0;
  Map<String, dynamic> currentPlayer = {};
  Map<String, dynamic> opponent = {};
  List<Map<String, dynamic>> players = [];

  final String baseUrl = 'https://par-impar.glitch.me';

  @override
  void initState() {
    super.initState();
    fetchPlayers();
  }

  Future<void> fetchPlayers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/jogadores'));
      if (response.statusCode == 200) {
        setState(() {
          players = List<Map<String, dynamic>>.from(json.decode(response.body)['jogadores']);
          for (var player in players) {
            if (player['username'] == null) {
              player['username'] = '';
            }
          }
        });
      } else {
        throw Exception('Failed to load players');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> registerPlayer(String name) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/novo'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': name}),
      );
      if (response.statusCode == 200) {
        setState(() {
          currentPlayer = {
            'nome': name,
            'dedos': 1,
            'valorAposta': 0,
            'parImpar': 0,
            'pontos': 1000,
          };
          players.add(currentPlayer);
          changeScreen(1);
        });
      } else {
        throw Exception('Failed to register player');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> placeBet(String username, int value, int parImpar, int number) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/aposta'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'valor': value,
          'parimpar': parImpar,
          'numero': number,
        }),
      );
      if (response.statusCode == 200) {
        changeScreen(2);
      } else {
        throw Exception('Failed to place bet');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>> playGame(String username1, String username2) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/jogar/$username1/$username2'));
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        setState(() {
          if (result.containsKey('msg') && result['msg'] == 'Ninguem ganhou!') {
            return;
          } else {
            currentPlayer['pontos'] += result['vencedor']['username'] == currentPlayer['nome']
                ? int.parse(result['vencedor']['valor'].toString())
                : -int.parse(result['perdedor']['valor'].toString());
            opponent['pontos'] += result['perdedor']['username'] == opponent['nome']
                ? -int.parse(result['perdedor']['valor'].toString())
                : int.parse(result['vencedor']['valor'].toString());
          }
        });
      } else {
        throw Exception('Failed to play game');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  void changeScreen(int newScreenId, [Map<String, dynamic>? player]) {
    setState(() {
      currentScreen = newScreenId;
      if (player != null) {
        opponent = player;
      }
    });
  }

  Widget displayScreen() {
    switch (currentScreen) {
      case 0:
        return Cadastro(registerPlayer);
      case 1:
        return Aposta(changeScreen, currentPlayer, placeBet);
      case 2:
        return Lista(changeScreen, players, currentPlayer['nome']);
      default:
        return Resultado(changeScreen, currentPlayer, opponent, playGame);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Par ou Ímpar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: displayScreen(),
    );
  }
}
