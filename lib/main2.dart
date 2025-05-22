import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  void trocarTema() {
    setState(() {
      modoEscuro = !modoEscuro;
      tema = modoEscuro ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Etan\u00f4mico',
      theme: temaClaro,
      darkTheme: temaEscuro,
      themeMode: tema,
      debugShowCheckedModeBanner: false,
      home: Splash(trocarTema: trocarTema),
    );
  }
}

class Splash extends StatefulWidget {
  final VoidCallback trocarTema;

  const Splash({super.key, required this.trocarTema});

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
          builder: (context) => TelaInicial(trocarTema: widget.trocarTema),
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

class TelaInicial extends StatelessWidget {
  final VoidCallback trocarTema;

  const TelaInicial({super.key, required this.trocarTema});

  @override
  Widget build(BuildContext context) {
    final bool modoEscuro = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: trocarTema,
            icon: Icon(modoEscuro ? Icons.light_mode : Icons.dark_mode),
          )
        ],
        toolbarHeight: 110,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 50),
              Image.asset('assets/images/Logo_Etan\u00f4mico.png', height: 60),
              const SizedBox(width: 3),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.05,
                  ),
                  child: Text(
                    'Etan\u00f4mico',
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
            ],
          ),
        ),
      ),
      body: Builder(
        builder: (context) {
          final bool isDark = Theme.of(context).brightness == Brightness.dark;
          double largura = MediaQuery.of(context).size.width;
          double altura = MediaQuery.of(context).size.height;
          double paddingLateral = largura * 0.05;
          double espacamentoTopo = altura * 0.04;
          double espacamentoEntreBotoes = altura * 0.05;

          Color backgroundColor = isDark
              ? Color.fromARGB(255, 31, 31, 31)
              : Color.fromARGB(247, 246, 244, 255);
          Color borderColor = isDark ? Colors.white : Colors.black;
          Color textColor = isDark ? Colors.white : Colors.black;

          return ListView(
            padding: EdgeInsets.only(
              left: paddingLateral,
              right: paddingLateral,
              top: espacamentoTopo,
            ),
            children: [
              botaoMenu(
                context,
                backgroundColor,
                borderColor,
                textColor,
                Icons.calculate_outlined,
                'Calculadora \u00c1lcool x Gasolina',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaComparativo(trocarTema: trocarTema),
                    ),
                  );
                },
              ),
              SizedBox(height: espacamentoEntreBotoes),
              botaoMenu(
                context,
                backgroundColor,
                borderColor,
                textColor,
                Icons.speed_outlined,
                'Calculadora de Consumo',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaConsumo(trocarTema: trocarTema),
                    ),
                  );
                },
              ),
              SizedBox(height: espacamentoEntreBotoes),
              botaoMenu(
                context,
                backgroundColor,
                borderColor,
                textColor,
                Icons.trending_up_outlined,
                'Monitoramento de Pre\u00e7os',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaPrecos(trocarTema: trocarTema),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget botaoMenu(BuildContext context, Color bgColor, Color borderColor, Color textColor, IconData icon, String texto, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
        backgroundColor: bgColor,
        side: BorderSide(color: borderColor, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: textColor, size: 22),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              texto,
              style: TextStyle(
                color: textColor,
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
    );
  }
}

// As telas abaixo devem ser ajustadas separadamente para remover depend\u00eancia da prop "tema"
class TelaComparativo extends StatelessWidget {
  final VoidCallback trocarTema;
  const TelaComparativo({super.key, required this.trocarTema});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Calculadora Álcool x Gasolina")));
  }
}

class TelaConsumo extends StatelessWidget {
  final VoidCallback trocarTema;
  const TelaConsumo({super.key, required this.trocarTema});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Calculadora de Consumo")));
  }
}

class TelaPrecos extends StatelessWidget {
  final VoidCallback trocarTema;
  const TelaPrecos({super.key, required this.trocarTema});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Monitoramento de Preços")));
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