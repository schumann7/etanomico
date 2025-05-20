import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

final NumberFormat moedaFormat = NumberFormat.currency(
  locale: 'pt_BR',
  symbol: 'R\$',
);
final NumberFormat inteiroFormat = NumberFormat.decimalPattern('pt_BR');

//import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode tema = ThemeMode.light;
  bool modoEscuro = false;

  void trocarTema() {
    setState(() {
      modoEscuro = !modoEscuro;
      tema = modoEscuro ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Etanômico',
      theme: temaClaro,
      darkTheme: temaEscuro,
      themeMode: tema,
      debugShowCheckedModeBanner: false,
      home: Splash(
        tema: tema,
        trocarTema: trocarTema,
      ),
    );
  }
}

class Splash extends StatefulWidget {
  final VoidCallback trocarTema;
  final ThemeMode tema;
  const Splash({super.key, required this.tema, required this.trocarTema});

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {

  ThemeMode tema = ThemeMode.light;
  bool modoEscuro = false;

  void trocarTema(){
  setState(() {
    tema = modoEscuro? ThemeMode.dark : ThemeMode.light;
    modoEscuro = !modoEscuro;
  });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TelaInicial(
        tema: widget.tema, trocarTema: widget.trocarTema,)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/splash-logo.png',
              width: 300,
              height: 300,
            ),
          ],
        ),
      ),
    );
  }
}

class TelaInicial extends StatefulWidget {
  final VoidCallback trocarTema;
  final ThemeMode tema;

  const TelaInicial({
    super.key,
    required this.trocarTema,
    required this.tema,
  });

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {

ThemeMode tema = ThemeMode.light;
bool modoEscuro = false;

  void trocarTema(){
  setState(() {
    tema = modoEscuro? ThemeMode.dark : ThemeMode.light;
    modoEscuro = !modoEscuro;
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: widget.trocarTema, icon: Icon(modoEscuro ? Icons.light_mode : Icons.dark_mode))],
        toolbarHeight: 110,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 50,),
              Image.asset('assets/images/Logo_Etanômico.png', height: 60),
            const SizedBox(width: 3),
              Flexible(
                child: Builder(
                  builder:
                      (context) => Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.05,
                        ),
                        child: Text(
                          'Etanômico',
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width < 400 ? 26 : 34,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Builder(
        builder: (context) {
          double largura = MediaQuery.of(context).size.width;
          double altura = MediaQuery.of(context).size.height;
          double paddingLateral = largura * 0.05;
          double espacamentoTopo = altura * 0.04;
          double espacamentoEntreBotoes = altura * 0.05;

          return Container(
            child: ListView(
              padding: EdgeInsets.only(
                left: paddingLateral,
                right: paddingLateral,
                top: espacamentoTopo,
              ),
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 10,
                    ),
                    backgroundColor: widget.tema == ThemeMode.dark? Color.fromARGB(255, 31, 31, 31) : Color.fromARGB(247, 246, 244, 255),
                    side: BorderSide(color: widget.tema == ThemeMode.dark? Colors.white : Colors.black, width: 1),
                    textStyle: TextStyle(color: widget.tema == ThemeMode.dark? Colors.white : Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TelaComparativo(tema: widget.tema, trocarTema: widget.trocarTema,),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calculate_outlined,
                        color: widget.tema == ThemeMode.dark? Colors.white : Colors.black,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          'Calculadora Álcool x Gasolina',
                          style: TextStyle(
                            color: widget.tema == ThemeMode.dark? Colors.white : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: espacamentoEntreBotoes),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 10,
                    ),
                    backgroundColor: widget.tema == ThemeMode.dark? Color.fromARGB(255, 31, 31, 31) : Color.fromARGB(247, 246, 244, 255),
                    side: BorderSide(color: widget.tema == ThemeMode.dark? Colors.white : Colors.black, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TelaConsumo(tema: widget.tema, trocarTema: widget.trocarTema),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.speed_outlined, color: widget.tema == ThemeMode.dark? Colors.white : Colors.black, size: 22),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          'Calculadora de Consumo',
                          style: TextStyle(
                            color: widget.tema == ThemeMode.dark? Colors.white : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: espacamentoEntreBotoes),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 10,
                    ),
                    backgroundColor: widget.tema == ThemeMode.dark? Color.fromARGB(255, 31, 31, 31) : Color.fromARGB(247, 246, 244, 255),
                    side: BorderSide(color: widget.tema == ThemeMode.dark? Colors.white : Colors.black, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TelaPrecos(tema: widget.tema, trocarTema: widget.trocarTema),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.trending_up_outlined,
                        color: widget.tema == ThemeMode.dark? Colors.white : Colors.black,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          'Monitoramento de Preços',
                          style: TextStyle(
                            color: widget.tema == ThemeMode.dark? Colors.white : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class TelaComparativo extends StatefulWidget {
  final VoidCallback trocarTema;
  final ThemeMode tema;

  const TelaComparativo({super.key, required this.tema, required this.trocarTema});

  @override
  State<TelaComparativo> createState() => _TelaComparativoState();
}

class _TelaComparativoState extends State<TelaComparativo> {

  final TextEditingController _controllergasolina = TextEditingController();
  final TextEditingController _controlleretanol = TextEditingController();
  String _comparacao = "";

  bool get modoEscuro => widget.tema == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: widget.trocarTema,icon: Icon(modoEscuro ? Icons.light_mode : Icons.dark_mode),)],
        toolbarHeight: 110,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: widget.tema == ThemeMode.dark ? Colors.white: Colors.black,
            size: 28,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: 'Voltar',
          splashRadius: 24,
        ),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/Logo_Etanômico.png', height: 60),
            const SizedBox(width: 3),
            Flexible(
              child: Builder(
                builder:
                    (context) => Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.05,
                      ),
                      child: Text(
                        'Etanômico',
                        style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.width < 400 ? 26 : 34,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
              ),
              child: TextField(
                controller: _controllergasolina,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  label: const Text("Valor da gasolina"),
                  border: const OutlineInputBorder(),
                  labelStyle: TextStyle(color: widget.tema == ThemeMode.dark ? Colors.white : Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: widget.tema == ThemeMode.dark ? Colors.white : Colors.black),
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    double parsed = double.parse(value) / 100;
                    _controllergasolina.value = TextEditingValue(
                      text: moedaFormat.format(parsed),
                      selection: TextSelection.collapsed(
                        offset: moedaFormat.format(parsed).length,
                      ),
                    );
                  }
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.07),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
              ),
              child: TextField(
                controller: _controlleretanol,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  label: const Text("Valor do etanol"),
                  labelStyle: TextStyle(color: widget.tema == ThemeMode.dark ? Colors.white : Colors.black),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: widget.tema == ThemeMode.dark ? Colors.white : Colors.black),
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    double parsed = double.parse(value) / 100;
                    _controlleretanol.value = TextEditingValue(
                      text: moedaFormat.format(parsed),
                      selection: TextSelection.collapsed(
                        offset: moedaFormat.format(parsed).length,
                      ),
                    );
                  }
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.07),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: widget.tema == ThemeMode.dark? Colors.white : Colors.black, width: 1),
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 30,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor: widget.tema == ThemeMode.dark? Color.fromARGB(255, 31, 31, 31) : Color.fromARGB(247, 246, 244, 255),
                ),
                child: Text(
                  'Confirmar',
                  style: TextStyle(color: widget.tema == ThemeMode.dark? Colors.white : Colors.black, fontSize: 15),
                ),
                onPressed: () {
                  if (_controllergasolina.text != "" &&
                      _controlleretanol.text != "") {
                    String g =
                        _controllergasolina.text
                            .replaceAll("R\$", "")
                            .replaceAll(".", "")
                            .replaceAll(",", ".")
                            .trim();
                    String e =
                        _controlleretanol.text
                            .replaceAll("R\$", "")
                            .replaceAll(".", "")
                            .replaceAll(",", ".")
                            .trim();

                    double valorgasolina = double.tryParse(g) ?? 0;
                    double valoretanol = double.tryParse(e) ?? 0;

                    setState(() {
                      if (valorgasolina > 0 && valoretanol > 0) {
                        _comparacao =
                            valoretanol <= valorgasolina * 0.7
                                ? "o álcool"
                                : "a gasolina";
                      } else {
                        _comparacao = "";
                      }
                      FocusScope.of(context).requestFocus(FocusNode());
                    });
                  }
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            Text(
              _comparacao.isEmpty
                  ? ""
                  : "Nessa situação, o combustível mais favorável é $_comparacao",
              style: const TextStyle(fontSize: 19),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class TelaConsumo extends StatefulWidget {
  const TelaConsumo({super.key, required this.tema, required this.trocarTema});
  final ThemeMode tema;
  final VoidCallback trocarTema; 

  @override
  State<TelaConsumo> createState() => _TelaConsumoState();
}

class _TelaConsumoState extends State<TelaConsumo> {
  final TextEditingController _precoController = TextEditingController();
  final TextEditingController _consumoController = TextEditingController();
  final TextEditingController _distanciaController = TextEditingController();
  String _resultado = "";

  bool modoEscuro = false;
  ThemeMode tema = ThemeMode.light;
  void trocarTema(){
  setState(() {
    tema = modoEscuro? ThemeMode.dark : ThemeMode.light;
    modoEscuro = !modoEscuro;
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: widget.trocarTema, icon: Icon(modoEscuro ? Icons.light_mode : Icons.dark_mode))],
        toolbarHeight: 110,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: widget.tema == ThemeMode.dark ? Colors.white: Colors.black,
            size: 28,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: 'Voltar',
          splashRadius: 24,
        ),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/Logo_Etanômico.png', height: 60),
            const SizedBox(width: 3),
            Flexible(
              child: Builder(
                builder:
                    (context) => Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.05,
                      ),
                      child: Text(
                        'Etanômico',
                        style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.width < 400 ? 26 : 34,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              TextField(
                controller: _precoController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: "Preço por litro (R\$)",
                  labelStyle: TextStyle(color: widget.tema == ThemeMode.dark ? Colors.white : Colors.black),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: widget.tema == ThemeMode.dark ? Colors.white : Colors.black),
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    double parsed = double.parse(value) / 100;
                    _precoController.value = TextEditingValue(
                      text: moedaFormat.format(parsed),
                      selection: TextSelection.collapsed(
                        offset: moedaFormat.format(parsed).length,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _consumoController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: "Consumo (L)",
                  labelStyle: TextStyle(color: widget.tema == ThemeMode.dark ? Colors.white : Colors.black),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: widget.tema == ThemeMode.dark ? Colors.white : Colors.black),
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    int parsed = int.parse(value.replaceAll('.', ''));
                    _consumoController.value = TextEditingValue(
                      text: inteiroFormat.format(parsed),
                      selection: TextSelection.collapsed(
                        offset: inteiroFormat.format(parsed).length,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _distanciaController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: "Distância percorrida (km)",
                  labelStyle: TextStyle(color: widget.tema == ThemeMode.dark ? Colors.white : Colors.black),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: widget.tema == ThemeMode.dark ? Colors.white : Colors.black),
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    int parsed = int.parse(value.replaceAll('.', ''));
                    _distanciaController.value = TextEditingValue(
                      text: inteiroFormat.format(parsed),
                      selection: TextSelection.collapsed(
                        offset: inteiroFormat.format(parsed).length,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: widget.tema == ThemeMode.dark ? Colors.white: Colors.black, width: 1),
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 30,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor: widget.tema == ThemeMode.dark ? const Color.fromARGB(255, 31, 31, 31): const Color.fromARGB(247, 246, 244, 255),
                ),
                child: Text(
                  'Calcular',
                  style: TextStyle(color: widget.tema == ThemeMode.dark ? Colors.white: Colors.black, fontSize: 15),
                ),
                onPressed: () {
                  if (_precoController.text.isNotEmpty &&
                      _consumoController.text.isNotEmpty &&
                      _distanciaController.text.isNotEmpty) {
                    String p = _precoController.text
                        .replaceAll("R\$", "")
                        .replaceAll(".", "")
                        .replaceAll(",", ".");
                    String c = _consumoController.text
                        .replaceAll(".", "")
                        .replaceAll(",", ".");
                    String d = _distanciaController.text
                        .replaceAll(".", "")
                        .replaceAll(",", ".");

                    double preco = double.parse(p);
                    double consumo = double.parse(c);
                    double distancia = double.parse(d);

                    double kmPorLitro = distancia / consumo;
                    double valorGasto = preco * consumo;

                    setState(() {
                      _resultado =
                          "Valor gasto com combustível: R\$${valorGasto.toStringAsFixed(2).replaceAll('.', ',').replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}\n"
                          "Consumo médio: ${kmPorLitro.toStringAsFixed(2).replaceAll('.', ',')} km/l";
                      FocusScope.of(context).requestFocus(FocusNode());
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              Text(
                _resultado,
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

class TelaPrecos extends StatefulWidget {
  const TelaPrecos({super.key, required this.tema, required this.trocarTema});
  final ThemeMode tema;
  final VoidCallback trocarTema;

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

ThemeMode tema = ThemeMode.light;
bool modoEscuro = false;

  void trocarTema(){
  setState(() {
    tema = modoEscuro? ThemeMode.dark : ThemeMode.light;
    modoEscuro = !modoEscuro;
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: widget.trocarTema, icon: Icon(modoEscuro ? Icons.light_mode : Icons.dark_mode))],
        toolbarHeight: 110,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: widget.tema == ThemeMode.dark ? Colors.white: Colors.black,
            size: 28,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: 'Voltar',
          splashRadius: 24,
        ),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/Logo_Etanômico.png', height: 60),
            const SizedBox(width: 3),
            Flexible(
              child: Builder(
                builder:
                    (context) => Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.05,
                      ),
                      child: Text(
                        'Etanômico',
                        style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.width < 400 ? 26 : 34,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 60),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: widget.tema == ThemeMode.dark ? Colors.white : Colors.black),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: widget.tema == ThemeMode.dark ? Colors.white : Colors.black),
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
                            style: TextStyle(color: widget.tema == ThemeMode.dark ? Colors.white : Colors.black),
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
                  dropdownColor: widget.tema == ThemeMode.dark ? const Color.fromARGB(255, 31, 31, 31): const Color.fromARGB(247, 246, 244, 255),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(color: widget.tema == ThemeMode.dark? Colors.white : Colors.black, width: 1),
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 30,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: widget.tema == ThemeMode.dark ? const Color.fromARGB(255, 31, 31, 31): const Color.fromARGB(247, 246, 244, 255), 
                  ),
                  child: Text(
                    'Confirmar',
                    style: TextStyle(color: widget.tema == ThemeMode.dark? Colors.white : Colors.black, fontSize: 15),
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
                            retorno = 'A gasolina em sua localização custa em média R\$$preco';
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
                preco == "" ? SizedBox(height: 200.0, width: 200.0,child: Center(child: CircularProgressIndicator()),)
                :Text(
                  retorno != " " ? retorno : "",
                  style: const TextStyle(fontSize: 19),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

ThemeData temaEscuro = ThemeData(
  appBarTheme: AppBarTheme(
    backgroundColor: const Color.fromARGB(255, 31, 31, 31),
    titleTextStyle: TextStyle(color: Colors.white),
    actionsIconTheme: IconThemeData(color: Colors.white)
  ),
  textTheme: const TextTheme(
    bodySmall: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    bodyLarge: TextStyle(color: Colors.white),
    labelSmall: TextStyle(color: Colors.white),
    labelMedium: TextStyle(color: Colors.white),
    labelLarge: TextStyle(color: Colors.white),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 31, 31, 31),
  buttonTheme: ButtonThemeData(buttonColor: const Color.fromARGB(255, 37, 34, 34),),
);

ThemeData temaClaro = ThemeData(
  appBarTheme: AppBarTheme(
    backgroundColor: const Color.fromARGB(247, 246, 244, 255),
    titleTextStyle: TextStyle(color: Colors.black),
    actionsIconTheme: IconThemeData(color: const Color.fromARGB(255, 37, 34, 34),)
  ),
  textTheme: const TextTheme(
    bodySmall: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
    bodyLarge: TextStyle(color: Colors.black),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(247, 246, 244, 255),
  buttonTheme: ButtonThemeData(buttonColor: const Color.fromARGB(247, 246, 244, 255),)
);

// Deve ser usado em uma função async
// final SharedPreferencesWithCache prefsWithCache =
//     await SharedPreferencesWithCache.create(
// cacheOptions: const SharedPreferencesWithCacheOptions(
//     // When an allowlist is included, any keys that aren't included cannot be used.
//     allowList: <String>{'repeat', 'action'},
//   ),
// );
// await prefsWithCache.setBool('repeat', true);
// await prefsWithCache.setString('action', 'Start');

// final bool? repeat = prefsWithCache.getBool('repeat');
// final String? action = prefsWithCache.getString('action');

// await prefsWithCache.remove('repeat');

// // Since the filter options are set at creation, they aren't needed during clear.
// await prefsWithCache.clear();
