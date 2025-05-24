import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'home.dart';

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