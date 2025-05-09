import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Etanômico',
    theme: ThemeData(
      primarySwatch: Colors.green,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: const TelaInicial(),
    debugShowCheckedModeBanner: false,
  ));
}

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/images/Logo_Etanômico.png'),
        title: Text('Etanômico'),
      ),
      body: Center(
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TelaComparativo(),
                  ),
                );
              },
              child: const Text('Calculadora Álcool x Gasolina'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TelaConsumo(),
                  ),
                );
              },
              child: const Text('Calculadora de Consumo'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TelaPrecos(),
                  ),
                );
              },
              child: const Text('Monitoraramento de Preços'),
            ),  
          ],
        ),
      ),
    );
  }
}

class TelaComparativo extends StatefulWidget {
  const TelaComparativo({super.key});

  @override
  State<TelaComparativo> createState() => _TelaComparativoState();
}

class _TelaComparativoState extends State<TelaComparativo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela Comparativa'),
      ),
      body: Center(
        child: Text('Tela Comparativa'),
      ),
    );
  }
}

class TelaConsumo extends StatefulWidget {
  const TelaConsumo ({super.key});

  @override
  State<TelaConsumo> createState() => _TelaConsumoState();
}

class _TelaConsumoState extends State<TelaConsumo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela Consumo'),
      ),
      body: Center(
        child: Text('Tela Consumo'),
      ),
    );
  }
}

class TelaPrecos extends StatefulWidget {
  const TelaPrecos ({super.key});

  @override
  State<TelaPrecos> createState() => _TelaPrecosState();
}

class _TelaPrecosState extends State<TelaPrecos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela Preços'),
      ),
      body: Center(
        child: Text('Tela Preços'),
      ),
    );
  }
}