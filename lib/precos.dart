import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TelaPrecos extends StatefulWidget {
  const TelaPrecos({
    super.key,
    required this.tema,
    required this.trocarTema,
    required this.iconeDefault,
  });
  final ThemeMode tema;
  final VoidCallback trocarTema;
  final Icon iconeDefault;

  @override
  State<TelaPrecos> createState() => _TelaPrecosState();
}

class _TelaPrecosState extends State<TelaPrecos> {
  final List<String> lista = [
    "BR",
    "AL",
    "AM",
    "CE",
    "DF",
    "ES",
    "GO",
    "MA",
    "MT",
    "MG",
    "PR",
    "PB",
    "PA",
    "PE",
    "RS",
    "RJ",
    "SC",
    "SP",
  ];
  String? _selectedItem;
  String preco = "indefinido";
  String retorno = " ";
  final _formKey = GlobalKey<FormState>();

  bool modoEscuro = false;

  @override
  Widget build(BuildContext context) {
    final Color appBarColor =
        widget.tema == ThemeMode.dark
            ? const Color.fromARGB(255, 31, 31, 31)
            : const Color.fromARGB(247, 246, 244, 255);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        actions: [
          IconButton(onPressed: widget.trocarTema, icon: widget.iconeDefault),
        ],
        toolbarHeight: 110,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: widget.tema == ThemeMode.dark ? Colors.white : Colors.black,
            size: 28,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: 'Voltar',
          splashRadius: 24,
        ),
        centerTitle: true,
        title: Image.asset(
          widget.tema == ThemeMode.dark
              ? 'assets/images/logo-dark-mode.png'
              : 'assets/images/logo-light-mode.png',
          height: 50,
        ),
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
                  labelStyle: TextStyle(
                    color:
                        widget.tema == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          widget.tema == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                    ),
                  ),
                  labelText: 'Selecione seu estado',
                  border: const OutlineInputBorder(),
                ),
                value: _selectedItem,
                items:
                    lista.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(
                            color:
                                widget.tema == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedItem = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Selecione um item';
                  }
                  return null;
                },
                dropdownColor:
                    widget.tema == ThemeMode.dark
                        ? const Color.fromARGB(255, 31, 31, 31)
                        : const Color.fromARGB(247, 246, 244, 255),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: BorderSide(
                    color:
                        widget.tema == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                    width: 1,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 30,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor:
                      widget.tema == ThemeMode.dark
                          ? const Color.fromARGB(255, 31, 31, 31)
                          : const Color.fromARGB(247, 246, 244, 255),
                ),
                child: Text(
                  'Confirmar',
                  style: TextStyle(
                    color:
                        widget.tema == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                    fontSize: 15,
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    preco = "";
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

                      if (json['precos']['gasolina'].containsKey(
                        _selectedItem!.toLowerCase(),
                      )) {
                        setState(() {
                          preco =
                              json['precos']['gasolina'][_selectedItem!
                                      .toLowerCase()]
                                  .toString();
                          retorno =
                              'A gasolina em sua localização custa em média R\$$preco';
                        });
                      }
                    } catch (e) {
                      setState(() {
                        retorno =
                            'Ocorreu um erro na busca do preço \n Por favor, tente novamente mais tarde.';
                        preco = "indefinido";
                      });
                    }
                  }
                },
              ),
              const SizedBox(height: 30),
              preco == ""
                  ? SizedBox(
                    height: 200.0,
                    width: 200.0,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 37, 136, 96),
                        ),
                      ),
                    ),
                  )
                  : Text(
                    retorno != " " ? retorno : "",
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
