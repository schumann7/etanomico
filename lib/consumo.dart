import 'package:flutter/material.dart';
import 'main.dart';
import 'package:flutter/services.dart';

class TelaConsumo extends StatefulWidget {
  const TelaConsumo({
    super.key,
    required this.tema,
    required this.trocarTema,
    required this.iconeDefault,
  });
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
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const SizedBox(height: 15),
            SizedBox(
              height: 60,
              child: TextField(
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
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: TextField(
                      controller: _consumoController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: litro ? "Consumo" : "Consumo médio",
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
                        suffix: TextButton(
                          onPressed: () {
                            setState(() {
                              litro = !litro;
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            padding: const EdgeInsets.only(left: 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            litro ? "L" : "km/L",
                            style: TextStyle(
                              color:
                                  widget.tema == ThemeMode.dark
                                      ? Colors.white
                                      : Colors.black,
                              fontSize: 19,
                            ),
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
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 60,
              child: TextField(
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
                      litro ? preco * consumo : preco * (distancia / consumo);

                  setState(() {
                    _resultado =
                        "Valor gasto com combustível: R\$${valorGasto.toStringAsFixed(2).replaceAll('.', ',').replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}\n${litro ? "Consumo médio: ${kmPorLitro.toStringAsFixed(2).replaceAll('.', ',')} km/L" : "Consumo: ${kmPorLitro.toStringAsFixed(2).replaceAll('.', ',')} L"}";
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
