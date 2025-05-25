import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  ThemeMode tema = ThemeMode.light;
  bool modoEscuro = false;
  Icon iconeDefault = Icon(Icons.light_mode);
  List<Color> cores = [
    Color.fromARGB(255, 31, 31, 31),
    Color.fromARGB(247, 246, 244, 255),
  ];

  @override
  void initState() {
    super.initState();
    _carregarTema();
  }

  void _carregarTema() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('modoEscuro')) {
      setState(() {
        modoEscuro = prefs.getBool('modoEscuro')!;
        tema = modoEscuro ? ThemeMode.dark : ThemeMode.light;
        iconeDefault = modoEscuro ? Icon(Icons.dark_mode) : Icon(Icons.light_mode);
      });
    } else {
      // Se não houver preferência salva, use o padrão do sistema
      final Brightness brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      setState(() {
        modoEscuro = brightness == Brightness.dark;
        tema = modoEscuro ? ThemeMode.dark : ThemeMode.light;
        iconeDefault = modoEscuro ? Icon(Icons.dark_mode) : Icon(Icons.light_mode);
      });
    }
  }

  void trocarTema() {
    setState(() {
      tema = modoEscuro ? ThemeMode.dark : ThemeMode.light;
      modoEscuro = !modoEscuro;
      if (modoEscuro) {
        iconeDefault = Icon(Icons.dark_mode);
      } else {
        iconeDefault = Icon(Icons.light_mode);
      }
      salvarTema(modoEscuro);
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
      home: TelaInicial(
        tema: tema,
        trocarTema: trocarTema,
        iconeDefault: iconeDefault,
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
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Color.fromARGB(255, 37, 136, 96),
    selectionHandleColor: Color.fromARGB(255, 37, 136, 96),
  ),
);

ThemeData temaClaro = ThemeData(
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 246, 244, 255),
    titleTextStyle: TextStyle(color: Colors.black),
    actionsIconTheme: IconThemeData(color: Color.fromARGB(255, 37, 34, 34)),
    iconTheme: IconThemeData(color: Colors.black),
  ),
  textTheme: const TextTheme(
    bodySmall: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
    bodyLarge: TextStyle(color: Colors.black),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 246, 244, 255),
  buttonTheme: ButtonThemeData(
    buttonColor: const Color.fromARGB(255, 246, 244, 255),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Color.fromARGB(255, 37, 136, 96),
    selectionHandleColor: Color.fromARGB(255, 37, 136, 96),
  ),
);

// Salvar tema
Future<void> salvarTema(bool modoEscuro) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('modoEscuro', modoEscuro);
}
