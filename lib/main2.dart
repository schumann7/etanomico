import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _temaAtual = ThemeMode.light;

  void _trocarTema() {
    setState(() {
      _temaAtual =
          _temaAtual == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Etanômico',
      theme: temaClaro,
      darkTheme: temaEscuro,
      themeMode: _temaAtual,
      home: TelaPrecos(
        trocarTema: _trocarTema,
        temaAtual: _temaAtual,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TelaPrecos extends StatefulWidget {
  final VoidCallback trocarTema;
  final ThemeMode temaAtual;

  const TelaPrecos({
    super.key,
    required this.trocarTema,
    required this.temaAtual,
  });

  @override
  State<TelaPrecos> createState() => _TelaPrecosState();
}

class _TelaPrecosState extends State<TelaPrecos> {
  final List<String> lista = [
    "BR", "AL", "AM", "CE", "DF", "ES", "GO", "MA", "MT",
    "MG", "PR", "PB", "PA", "PE", "RS", "RJ", "SC", "SP",
  ];
  String? _selectedItem;
  String preco = "indefinido";
  String retorno = "";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final bool modoEscuro = widget.temaAtual == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 110,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 28),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Voltar',
          splashRadius: 24,
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/Logo_Etanômico.png', height: 60),
            const SizedBox(width: 3),
            Flexible(
              child: Builder(
                builder: (context) => Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.05,
                  ),
                  child: Text(
                    'Etanômico',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width < 400 ? 26 : 34,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              modoEscuro ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: widget.trocarTema,
            tooltip: 'Trocar tema',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 60),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: modoEscuro ? Colors.white : Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: modoEscuro ? Colors.white : Colors.black),
                  ),
                  labelText: 'Selecione seu estado',
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: modoEscuro
                      ? const Color.fromARGB(255, 58, 58, 58)
                      : const Color.fromARGB(247, 246, 244, 255),
                ),
                value: _selectedItem,
                items: lista.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(color: modoEscuro ? Colors.white : Colors.black),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedItem = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Selecione um item' : null,
                dropdownColor: modoEscuro
                    ? const Color.fromARGB(255, 37, 34, 34)
                    : const Color.fromARGB(247, 246, 244, 255),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: modoEscuro ? Colors.white : Colors.black, width: 1),
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'Confirmar',
                  style: TextStyle(
                    color: modoEscuro ? Colors.white : Colors.black,
                    fontSize: 15,
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    preco = "";
                    retorno = "";
                  });

                  if (_selectedItem != null) {
                    try {
                      final response = await http.get(
                        Uri.parse('https://combustivelapi.com.br/api/precos'),
                        headers: {
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                      );
                      final json = jsonDecode(response.body);

                      if (json['precos']['gasolina']
                          .containsKey(_selectedItem!.toLowerCase())) {
                        setState(() {
                          preco = json['precos']['gasolina']
                                  [_selectedItem!.toLowerCase()]
                              .toString();
                          retorno =
                              'A gasolina em sua localização custa em média R\$$preco';
                        });
                      }
                    } catch (e) {
                      setState(() {
                        retorno =
                            'Ocorreu um erro na busca do preço.\nPor favor, tente novamente mais tarde.';
                        preco = "indefinido";
                      });
                    }
                  }
                },
              ),
              const SizedBox(height: 30),
              preco == ""
                  ? const Center(child: CircularProgressIndicator())
                  : Text(
                      retorno,
                      style: const TextStyle(fontSize: 19),
                      textAlign: TextAlign.center,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

ThemeData temaEscuro = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 37, 34, 34),
    titleTextStyle: TextStyle(color: Colors.white),
    actionsIconTheme: IconThemeData(color: Colors.white),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 37, 34, 34),
);

ThemeData temaClaro = ThemeData(
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(247, 246, 244, 255),
    titleTextStyle: TextStyle(color: Colors.black),
    actionsIconTheme: IconThemeData(color: Colors.black),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(247, 246, 244, 255),
);
