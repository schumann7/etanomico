import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Etanômico',
      home: const TelaInicial(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 110,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/Logo_Etanômico.png', height: 60),
            const SizedBox(width: 2),
            Flexible(
              child: Builder(
                builder:
                    (context) => Padding(
                      padding: const EdgeInsets.only(top: 25),
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
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.black, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TelaComparativo(),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(Icons.calculate_outlined, color: Colors.black, size: 22),
                    SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        'Calculadora Álcool x Gasolina',
                        style: TextStyle(
                          color: Colors.black,
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
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.black, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TelaConsumo(),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(Icons.speed_outlined, color: Colors.black, size: 22),
                    SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        'Calculadora de Consumo',
                        style: TextStyle(
                          color: Colors.black,
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
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.black, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TelaPrecos(),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(Icons.trending_up_outlined, color: Colors.black, size: 22),
                    SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        'Monitoramento de Preços',
                        style: TextStyle(
                          color: Colors.black,
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
  const TelaComparativo({super.key});

  @override
  State<TelaComparativo> createState() => _TelaComparativoState();
}

class _TelaComparativoState extends State<TelaComparativo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Calculadora Álcool x Gasolina'),
      ),
    );
  }
}

class TelaConsumo extends StatefulWidget {
  const TelaConsumo({super.key});

  @override
  State<TelaConsumo> createState() => _TelaConsumoState();
}

class _TelaConsumoState extends State<TelaConsumo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Calculadora de Consumo')),
    );
  }
}

class TelaPrecos extends StatefulWidget {
  const TelaPrecos({super.key});

  @override
  State<TelaPrecos> createState() => _TelaPrecosState();
}

class _TelaPrecosState extends State<TelaPrecos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Monitoramento de preços')),
    );
  }
}
