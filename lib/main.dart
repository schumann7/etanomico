import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:shared_preferences/shared_preferences.dart';

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
        backgroundColor: const Color.fromARGB(247, 246, 244, 255),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/Logo_Etanômico.png', height: 60),
            const SizedBox(width: 3),
            Flexible(
              child: Builder(
                builder:
                    (context) => Padding(
                      padding: const EdgeInsets.only(top: 35),
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

          return Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(247, 246, 244, 255),
            ),
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
                    backgroundColor: const Color.fromARGB(247, 246, 244, 255),
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
                      Icon(
                        Icons.calculate_outlined,
                        color: Colors.black,
                        size: 22,
                      ),
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
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 10,
                    ),
                    backgroundColor: const Color.fromARGB(247, 246, 244, 255),
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
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 10,
                    ),
                    backgroundColor: const Color.fromARGB(247, 246, 244, 255),
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
                      Icon(
                        Icons.trending_up_outlined,
                        color: Colors.black,
                        size: 22,
                      ),
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
            ),
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
  final TextEditingController _controllergasolina = TextEditingController();
  final TextEditingController _controlleretanol = TextEditingController();
  String _comparacao = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 110,
        backgroundColor: const Color.fromARGB(247, 246, 244, 255),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
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
                builder: (context) => Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Text(
                    'Etanômico',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width < 400 ? 26 : 34,
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
        color: const Color.fromARGB(247, 246, 244, 255),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controllergasolina,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]'))],
                decoration: const InputDecoration(
                  label: Text("Valor da gasolina"),
                  border: OutlineInputBorder(),        
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            )),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controlleretanol,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  label: Text("Valor do etanol"),
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            )),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: Colors.black, width: 1),
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 30,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor: const Color.fromARGB(247, 246, 244, 255),
                ),
                child: const Text(
                  'Confirmar',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
                onPressed: () {
                  if (_controllergasolina.text != "" &&
                      _controlleretanol.text != "") {

                    String g = _controllergasolina.text;
                    String e = _controlleretanol.text;

                    g = g.replaceAll(",", ".");
                    e = e.replaceAll(",", ".");

                    double valorgasolina =
                        double.parse(g);
                    double valoretanol = double.parse(e);

                    setState(() {
                      _comparacao = valoretanol <= valorgasolina * 0.7
                          ? "o álcool"
                          : "a gasolina";
                      
                      FocusScope.of(context).requestFocus(FocusNode());
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 30),
            Text(
              _controllergasolina.text + _controlleretanol.text == ""
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
  const TelaConsumo({super.key});

  @override
  State<TelaConsumo> createState() => _TelaConsumoState();
}

class _TelaConsumoState extends State<TelaConsumo> {
  final TextEditingController _precoController = TextEditingController();
  final TextEditingController _consumoController = TextEditingController();
  final TextEditingController _distanciaController = TextEditingController();
  String _resultado = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 110,
        backgroundColor: const Color.fromARGB(247, 246, 244, 255),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
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
                builder: (context) => Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Text(
                    'Etanômico',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width < 400 ? 26 : 34,
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
        decoration: const BoxDecoration(
          color: Color.fromARGB(247, 246, 244, 255),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              TextField(
                controller: _precoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Preço por litro (R\$)",
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _consumoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Consumo (L)",
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _distanciaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Distância percorrida (km)",
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(247, 246, 244, 255),
                  side: const BorderSide(color: Colors.black, width: 1),
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 30,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Calcular',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
                onPressed: () {
                  if (_precoController.text.isNotEmpty &&
                      _consumoController.text.isNotEmpty &&
                      _distanciaController.text.isNotEmpty) {

                    String p = _precoController.text;
                    String c = _consumoController.text;
                    String d = _distanciaController.text;

                    p = p.replaceAll(",", ".");
                    c = c.replaceAll(",", ".");
                    d = d.replaceAll(",", ".");
                    
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
  const TelaPrecos({super.key});

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
  String preco = "";
  String retorno = "";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 110,
        backgroundColor: const Color.fromARGB(247, 246, 244, 255),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
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
                      padding: const EdgeInsets.only(top: 35),
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
        color: const Color.fromARGB(247, 246, 244, 255),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 60),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Selecione seu estado',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Color.fromARGB(247, 246, 244, 255),
                  ),
                  value: _selectedItem,
                  items:
                      lista.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(color: Colors.black),
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
                  dropdownColor: const Color.fromARGB(247, 246, 244, 255),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(247, 246, 244, 255),
                    side: const BorderSide(color: Colors.black, width: 1),
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 30,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Confirmar',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  onPressed: () async {
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
                        });
                      }
                    }
                  },
                ),
                const SizedBox(height: 30),
                Text(
                  retorno != "" ? retorno : "",
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