import 'package:flutter/material.dart';
import 'comparativo.dart';
import 'consumo.dart';
import 'precos.dart';
import 'gastos.dart';

class TelaInicial extends StatefulWidget {
  final VoidCallback trocarTema;
  final ThemeMode tema;
  final Icon iconeDefault;

  const TelaInicial({
    super.key,
    required this.trocarTema,
    required this.tema,
    required this.iconeDefault,
  });

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
        toolbarHeight: 110,
        automaticallyImplyLeading: false,
        title: Image.asset(
          widget.tema == ThemeMode.dark
              ? 'assets/images/logo-dark-mode.png'
              : 'assets/images/logo-light-mode.png',
          height: 50,
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: widget.trocarTema, icon: widget.iconeDefault),
        ],
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
                        'Comparador Álcool x Gasolina',
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
