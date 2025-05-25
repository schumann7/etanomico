import 'package:flutter/material.dart';
import 'main.dart';
import 'package:flutter/services.dart';

class TelaComparativo extends StatefulWidget {
  final VoidCallback trocarTema;
  final ThemeMode tema;
  final Icon iconeDefault;

  const TelaComparativo({
    super.key,
    required this.trocarTema,
    required this.tema,
    required this.iconeDefault,
  });

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
