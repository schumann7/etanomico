import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';

final NumberFormat moedaFormat = NumberFormat.currency(
  locale: 'pt_BR',
  symbol: 'R\$',
);
final NumberFormat inteiroFormat = NumberFormat.decimalPattern('pt_BR');

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode tema = ThemeMode.dark;
  bool modoEscuro = false;
  Icon iconeDefault = Icon(Icons.light_mode);
  List<Color> cores = [Color.fromARGB(255, 31, 31, 31), Color.fromARGB(247, 246, 244, 255), Colors.white, Colors.black];

    void trocarTema() {
    setState(() {
      tema = modoEscuro ? ThemeMode.dark : ThemeMode.light;
      modoEscuro = !modoEscuro;
      if(modoEscuro){
        iconeDefault = Icon(Icons.dark_mode);
      } else {
        iconeDefault = Icon(Icons.light_mode);
      }

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
      home: TelaInicial(tema: tema, trocarTema: trocarTema, iconeDefault: iconeDefault,),
    );
  }
}

class Splash extends StatefulWidget {
  final VoidCallback trocarTema;
  final ThemeMode tema;
  final Icon iconeDefault;
  const Splash({super.key, required this.tema, required this.trocarTema, required this.iconeDefault});

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  TelaInicial(tema: widget.tema, trocarTema: widget.trocarTema, iconeDefault: widget.iconeDefault,),
        ),
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
  final Icon iconeDefault;

  const TelaInicial({super.key, required this.trocarTema, required this.tema, required this.iconeDefault});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
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
          IconButton(
            onPressed: widget.trocarTema,
            icon: widget.iconeDefault,
          ),
        ],
        toolbarHeight: 110,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 50),
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
                                MediaQuery.of(context).size.width < 400
                                    ? 26
                                    : 34,
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

          return ListView(
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
                  backgroundColor:
                      widget.tema == ThemeMode.dark
                          ? Color.fromARGB(255, 31, 31, 31)
                          : Color.fromARGB(247, 246, 244, 255),
                  side: BorderSide(
                    color:
                        widget.tema == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => TelaComparativo(
                            tema: widget.tema,
                            trocarTema: widget.trocarTema,
                            iconeDefault: widget.iconeDefault,
                          ),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calculate_outlined,
                      color:
                          widget.tema == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        'Calculadora Álcool x Gasolina',
                        style: TextStyle(
                          color:
                              widget.tema == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
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
                  backgroundColor:
                      widget.tema == ThemeMode.dark
                          ? Color.fromARGB(255, 31, 31, 31)
                          : Color.fromARGB(247, 246, 244, 255),
                  side: BorderSide(
                    color:
                        widget.tema == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => TelaConsumo(
                            tema: widget.tema,
                            trocarTema: widget.trocarTema,
                            iconeDefault: widget.iconeDefault,
                          ),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.speed_outlined,
                      color:
                          widget.tema == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        'Calculadora de Consumo',
                        style: TextStyle(
                          color:
                              widget.tema == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
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
                  backgroundColor:
                      widget.tema == ThemeMode.dark
                          ? Color.fromARGB(255, 31, 31, 31)
                          : Color.fromARGB(247, 246, 244, 255),
                  side: BorderSide(
                    color:
                        widget.tema == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => TelaPrecos(
                            tema: widget.tema,
                            trocarTema: widget.trocarTema,
                            iconeDefault: widget.iconeDefault,
                          ),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.trending_up_outlined,
                      color:
                          widget.tema == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        'Monitoramento de Preços',
                        style: TextStyle(
                          color:
                              widget.tema == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
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
                  backgroundColor:
                      widget.tema == ThemeMode.dark
                          ? Color.fromARGB(255, 31, 31, 31)
                          : Color.fromARGB(247, 246, 244, 255),
                  side: BorderSide(
                    color:
                        widget.tema == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => TelaRegistroGastos(
                            tema: widget.tema,
                            trocarTema: widget.trocarTema,
                            iconeDefault: widget.iconeDefault,
                          ),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      color:
                          widget.tema == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        'Registro de Gastos',
                        style: TextStyle(
                          color:
                              widget.tema == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
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
          );
        },
      ),
    );
  }
}

class TelaComparativo extends StatefulWidget {
  final VoidCallback trocarTema;
  final ThemeMode tema;
  final Icon iconeDefault;

  const TelaComparativo({super.key, required this.trocarTema, required this.tema, required this.iconeDefault});

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
    final Color appBarColor =
        widget.tema == ThemeMode.dark
            ? const Color.fromARGB(255, 31, 31, 31)
            : const Color.fromARGB(247, 246, 244, 255);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        actions: [
          IconButton(
            onPressed: widget.trocarTema,
            icon: widget.iconeDefault,
          ),
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
      body: ListView(
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
                labelStyle: TextStyle(
                  color:
                      widget.tema == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                ),
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color:
                        widget.tema == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                  ),
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
                        ? Color.fromARGB(255, 31, 31, 31)
                        : Color.fromARGB(247, 246, 244, 255),
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
    );
  }
}

class TelaConsumo extends StatefulWidget {
  const TelaConsumo({super.key, required this.tema, required this.trocarTema, required this.iconeDefault});
  final ThemeMode tema;
  final VoidCallback trocarTema;
  final Icon iconeDefault;

  @override
  State<TelaConsumo> createState() => _TelaConsumoState();
}

class _TelaConsumoState extends State<TelaConsumo> {
  final TextEditingController _precoController = TextEditingController();
  final TextEditingController _consumoController = TextEditingController();
  final TextEditingController _distanciaController = TextEditingController();
  String _resultado = "";
  bool litro = true;

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
          IconButton(
            onPressed: widget.trocarTema,
            icon: widget.iconeDefault,
          ),
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
      body: Padding(
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
                labelStyle: TextStyle(
                  color:
                      widget.tema == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                ),
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color:
                        widget.tema == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                  ),
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _consumoController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: litro ? "Consumo (L)" : "Consumo (km/L)",
                      labelStyle: TextStyle(
                        color:
                            widget.tema == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                      ),
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color:
                              widget.tema == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                        ),
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
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      litro = !litro;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(eccentricity: 0.5),
                    side: BorderSide(
                      color:
                          widget.tema == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                      width: 1,
                    ),
                    backgroundColor:
                        widget.tema == ThemeMode.dark
                            ? const Color.fromARGB(255, 31, 31, 31)
                            : const Color.fromARGB(247, 246, 244, 255),
                  ),
                  child: Text(
                    litro ? "km/L" : "L",
                    style: TextStyle(
                      color:
                          widget.tema == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _distanciaController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: "Distância percorrida (km)",
                labelStyle: TextStyle(
                  color:
                      widget.tema == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                ),
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color:
                        widget.tema == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                  ),
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
                'Calcular',
                style: TextStyle(
                  color:
                      widget.tema == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                  fontSize: 15,
                ),
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
                  double valorGasto =
                      litro ? preco * consumo : preco * distancia;

                  setState(() {
                    _resultado =
                        "Valor gasto com combustível: R\$${valorGasto.toStringAsFixed(2).replaceAll('.', ',').replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}\n"
                        "Consumo médio: ${kmPorLitro.toStringAsFixed(2).replaceAll('.', ',')} ${litro? "km/L" : "L"}";
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
    );
  }
}

class TelaPrecos extends StatefulWidget {
  const TelaPrecos({super.key, required this.tema, required this.trocarTema, required this.iconeDefault});
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
          IconButton(
            onPressed: widget.trocarTema,
            icon: widget.iconeDefault,
          ),
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
                    child: Center(child: CircularProgressIndicator()),
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

class TelaRegistroGastos extends StatefulWidget {
  final ThemeMode tema;
  final VoidCallback trocarTema;
  final Icon iconeDefault;

  const TelaRegistroGastos({
    super.key,
    required this.tema,
    required this.trocarTema,
    required this.iconeDefault
  });

  @override
  State<TelaRegistroGastos> createState() => _TelaRegistroGastosState();
}

class FuelExpense {
  final double amount;
  final DateTime date;

  FuelExpense({required this.amount, required this.date});

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'date': date.toIso8601String(),
  };

  factory FuelExpense.fromJson(Map<String, dynamic> json) =>
      FuelExpense(amount: json['amount'], date: DateTime.parse(json['date']));
}

class _TelaRegistroGastosState extends State<TelaRegistroGastos> {
  List<FuelExpense> _expenses = [];
  final _amountController = TextEditingController();
  final _currencyFormatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );
  DateTime _selectedDate = DateTime.now();
  String _selectedPeriod = 'Mês';

  bool get modoEscuro => widget.tema == ThemeMode.dark;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
    _amountController.addListener(_onAmountChanged);
  }

  @override
  void dispose() {
    _amountController.removeListener(_onAmountChanged);
    _amountController.dispose();
    super.dispose();
  }

  void _onAmountChanged() {
    String text = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (text.isEmpty) text = '0';
    double value = double.parse(text) / 100;
    String newText = _currencyFormatter.format(value);
    if (_amountController.text != newText) {
      _amountController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }
  }

  double _parseCurrency(String text) {
    String cleaned = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.isEmpty) return 0.0;
    return double.parse(cleaned) / 100;
  }

  Future<void> _loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('expenses');
    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);
      setState(() {
        _expenses = jsonList.map((json) => FuelExpense.fromJson(json)).toList();
      });
    }
  }

  Future<void> _saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _expenses.map((e) => e.toJson()).toList();
    await prefs.setString('expenses', jsonEncode(jsonList));
  }

  void _addExpense() {
    final amount = _parseCurrency(_amountController.text);
    if (amount > 0) {
      setState(() {
        _expenses.add(FuelExpense(amount: amount, date: _selectedDate));
        _amountController.clear();
        _selectedDate = DateTime.now();
      });
      _saveExpenses();
    }
  }

  List<FuelExpense> _filteredExpenses() {
    DateTime now = DateTime.now();
    if (_selectedPeriod == 'Semana') {
      DateTime weekStart = now.subtract(Duration(days: now.weekday - 1));
      return _expenses
          .where(
            (e) =>
                e.date.isAfter(weekStart.subtract(Duration(days: 1))) &&
                e.date.isBefore(weekStart.add(Duration(days: 7))),
          )
          .toList();
    } else if (_selectedPeriod == 'Mês') {
      return _expenses
          .where((e) => e.date.year == now.year && e.date.month == now.month)
          .toList();
    } else if (_selectedPeriod == 'Ano') {
      return _expenses.where((e) => e.date.year == now.year).toList();
    }
    return _expenses;
  }

  List<BarChartGroupData> _buildChartData() {
    final filtered = _filteredExpenses();
    Map<int, double> grouped = {};

    if (_selectedPeriod == 'Semana') {
      for (var e in filtered) {
        grouped[e.date.weekday] = (grouped[e.date.weekday] ?? 0) + e.amount;
      }
      final bars = List.generate(7, (i) {
        double y = grouped[i + 1] ?? 0;
        return BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: y,
              color: Colors.blue,
              width: 18,
              borderRadius: BorderRadius.circular(4),
              rodStackItems: [],
            ),
          ],
          showingTooltipIndicators: y > 0 ? [0] : [],
        );
      });
      if (bars.every((bar) => bar.barRods.first.toY == 0)) return [];
      return bars;
    } else if (_selectedPeriod == 'Mês') {
      for (var e in filtered) {
        grouped[e.date.day] = (grouped[e.date.day] ?? 0) + e.amount;
      }
      final daysWithExpense = grouped.keys.toList()..sort();
      final bars =
          daysWithExpense.map((day) {
            double y = grouped[day] ?? 0;
            return BarChartGroupData(
              x: day,
              barRods: [
                BarChartRodData(
                  toY: y,
                  color: Color.fromARGB(255, 37, 136, 96),
                  width: 18,
                  borderRadius: BorderRadius.circular(4),
                  rodStackItems: [],
                ),
              ],
              showingTooltipIndicators: y > 0 ? [0] : [],
            );
          }).toList();
      if (bars.isEmpty) return [];
      return bars;
    } else if (_selectedPeriod == 'Ano') {
      for (var e in filtered) {
        grouped[e.date.month] = (grouped[e.date.month] ?? 0) + e.amount;
      }
      final bars = List.generate(12, (i) {
        double y = grouped[i + 1] ?? 0;
        return BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: y,
              color: Colors.blue,
              width: 18,
              borderRadius: BorderRadius.circular(4),
              rodStackItems: [],
            ),
          ],
          showingTooltipIndicators: y > 0 ? [0] : [],
        );
      });
      if (bars.every((bar) => bar.barRods.first.toY == 0)) return [];
      return bars;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final chartData = _buildChartData();
    final filtered = _filteredExpenses();
    final total = filtered.fold<double>(0, (sum, e) => sum + e.amount);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: widget.trocarTema,
            icon: widget.iconeDefault,
          ),
        ],
        toolbarHeight: 110,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: modoEscuro ? Colors.white : Colors.black,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Registrar gasto",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: 'Valor do gasto',
                      labelStyle: TextStyle(color: modoEscuro? Colors.white : Colors.black),
                      prefixIcon: Icon(Icons.local_gas_station, color: modoEscuro? Colors.white : Colors.black,),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: modoEscuro? Colors.white : Colors.black,)),
                      filled: true,
                      fillColor: modoEscuro? Color.fromARGB(255, 31, 31, 31) : Color.fromARGB(247, 246, 244, 255),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 10,
                    ),
                    backgroundColor: modoEscuro
                        ? const Color.fromARGB(255, 31, 31, 31)
                        : const Color.fromARGB(247, 246, 244, 255),
                    side: BorderSide(
                      color: modoEscuro ? Colors.white : Colors.black,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                  child: Text(
                    "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                    style: TextStyle(
                      color: modoEscuro ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 10,
                    ),
                    backgroundColor: modoEscuro
                        ? const Color.fromARGB(255, 31, 31, 31)
                        : const Color.fromARGB(247, 246, 244, 255),
                    side: BorderSide(
                      color: modoEscuro ? Colors.white : Colors.black,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    final amount = _parseCurrency(_amountController.text);
                    if (amount <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Digite um valor válido!'),
                        ),
                      );
                      return;
                    }
                    _addExpense();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gasto adicionado!')),
                    );
                  },
                  child: Text(
                    'Adicionar',
                    style: TextStyle(
                      color: modoEscuro ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Período:'),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedPeriod,
                  items:
                      ['Semana', 'Mês', 'Ano']
                          .map(
                            (p) => DropdownMenuItem(value: p, child: Text(p, style: TextStyle(color: modoEscuro? Colors.white : Colors.black),)),
                          )
                          .toList(),
                  onChanged: (v) {
                    setState(() {
                      _selectedPeriod = v!;
                    });
                  },
                  dropdownColor: modoEscuro? Color.fromARGB(255, 31, 31, 31) : Color.fromARGB(247, 246, 244, 255),
                ),
                const Spacer(),
                Text(
                  "Total: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(total)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              flex: 2,
              child:
                  chartData.isEmpty
                      ? const Center(
                        child: Text('Sem dados para o período selecionado.'),
                      )
                      : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: BarChart(
                          BarChartData(
                            barGroups: chartData,
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              getDrawingHorizontalLine:
                                  (value) => FlLine(
                                    color: Colors.grey,
                                    strokeWidth: 0.5,
                                  ),
                            ),
                            borderData: FlBorderData(
                              show: true,
                              border: const Border(
                                left: BorderSide(color: Colors.black26),
                                bottom: BorderSide(color: Colors.black26),
                              ),
                            ),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 60,
                                  getTitlesWidget: (value, meta) {
                                    final maxY = chartData
                                        .map((e) => e.barRods.first.toY)
                                        .fold<double>(
                                          0,
                                          (prev, el) => el > prev ? el : prev,
                                        );
                                    final interval = (maxY / 4).ceilToDouble();
                                    if (value == 0 ||
                                        (interval > 0 &&
                                            value % interval == 0)) {
                                      final formatted = NumberFormat.currency(
                                        locale: 'pt_BR',
                                        symbol: 'R\$',
                                      ).format(value);
                                      return Text(
                                        formatted,
                                        style: const TextStyle(fontSize: 12),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    if (_selectedPeriod == 'Semana') {
                                      const days = [
                                        'Dom',
                                        'Seg',
                                        'Ter',
                                        'Qua',
                                        'Qui',
                                        'Sex',
                                        'Sáb',
                                      ];
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 4.0,
                                        ),
                                        child: Text(
                                          days[value.toInt() % 7],
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      );
                                    } else if (_selectedPeriod == 'Mês') {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 4.0,
                                        ),
                                        child: Text(
                                          '${value.toInt()}',
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      );
                                    } else if (_selectedPeriod == 'Ano') {
                                      const months = [
                                        'Jan',
                                        'Fev',
                                        'Mar',
                                        'Abr',
                                        'Mai',
                                        'Jun',
                                        'Jul',
                                        'Ago',
                                        'Set',
                                        'Out',
                                        'Nov',
                                        'Dez',
                                      ];
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 4.0,
                                        ),
                                        child: Text(
                                          months[value.toInt() % 12],
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      );
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            barTouchData: BarTouchData(
                              enabled: true,
                              touchTooltipData: BarTouchTooltipData(
                                tooltipBgColor: Color.fromARGB(255, 37, 136, 96),
                                getTooltipItem: (
                                  group,
                                  groupIndex,
                                  rod,
                                  rodIndex,
                                ) {
                                  final formatted = NumberFormat.currency(
                                    locale: 'pt_BR',
                                    symbol: 'R\$',
                                  ).format(rod.toY);
                                  return BarTooltipItem(
                                    formatted,
                                    const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                            ),
                            extraLinesData: ExtraLinesData(),
                            maxY:
                                chartData
                                    .map((e) => e.barRods.first.toY)
                                    .fold<double>(
                                      0,
                                      (prev, el) => el > prev ? el : prev,
                                    ) +
                                20,
                          ),
                        ),
                      ),
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Histórico de gastos",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Expanded(
              flex: 3,
              child:
                  filtered.isEmpty
                      ? const Center(child: Text('Nenhum gasto registrado.'))
                      : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          final e = filtered[filtered.length - 1 - i];
                          return Dismissible(
                            key: Key('${e.date.toIso8601String()}-${e.amount}'),
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 20),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            secondaryBackground: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (direction) {
                              setState(() {
                                _expenses.removeWhere(
                                  (exp) =>
                                      exp.amount == e.amount &&
                                      exp.date == e.date,
                                );
                              });
                              _saveExpenses();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Gasto removido!'),
                                ),
                              );
                            },
                            child: Card(
                              color: modoEscuro? Color.fromARGB(255, 31, 31, 31) : Color.fromARGB(247, 246, 244, 255),
                              child: ListTile(
                                leading: Icon(Icons.local_gas_station, color: modoEscuro? Colors.white : Colors.black),
                                title: Text(
                                  NumberFormat.currency(
                                    locale: 'pt_BR',
                                    symbol: 'R\$',
                                  ).format(e.amount),
                                  style: TextStyle(color: modoEscuro? Colors.white : Colors.black),
                                ),
                                subtitle: Text(
                                  '${e.date.day}/${e.date.month}/${e.date.year}',
                                  style: TextStyle(color: modoEscuro? Colors.white : Colors.black)
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

ThemeData temaEscuro = ThemeData(
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 31, 31, 31),
    titleTextStyle: TextStyle(color: Colors.white),
    actionsIconTheme: IconThemeData(color: Colors.white),
    iconTheme: IconThemeData(color: Colors.white),
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
  buttonTheme: ButtonThemeData(
    buttonColor: const Color.fromARGB(255, 37, 34, 34),
  ),
);

ThemeData temaClaro = ThemeData(
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(247, 246, 244, 255),
    titleTextStyle: TextStyle(color: Colors.black),
    actionsIconTheme: IconThemeData(color: Color.fromARGB(255, 37, 34, 34)),
    iconTheme: IconThemeData(color: Colors.black),
  ),
  textTheme: const TextTheme(
    bodySmall: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
    bodyLarge: TextStyle(color: Colors.black),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(247, 246, 244, 255),
  buttonTheme: ButtonThemeData(
    buttonColor: const Color.fromARGB(247, 246, 244, 255),
  ),
);