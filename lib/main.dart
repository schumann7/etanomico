import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  final List<String> lista = ["BR", "AL", "AM",	"CE",	"DF",	"ES",	"GO",	"MA",	"MT",	"MG",	"PR",	"PB",	"PA",	"PE",	"RS",	"RJ",	"SC",	"SP"];
  String? _selectedItem;
  String preco = "";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Monitoramento de Preços'), actions: [Image.asset("assets/images/Logo_Etanômico.png")],),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Selecione seu estado',
                  border: OutlineInputBorder(),
                ),
                value: _selectedItem,
                items: lista.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
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
              ),
              
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Confirmar'),
               onPressed: () async {
                if (_selectedItem != null) {
                  try {
                    final response = await http.get(
                      Uri.parse('https://combustivelapi.com.br/api/precos'),
                      headers: {'Content-Type': 'application/json; charset=UTF-8'},
                    );

                    final json = jsonDecode(response.body);
                    
                    if (json['precos']['gasolina'].containsKey(_selectedItem!.toLowerCase())) {
                      setState(() {
                        preco = json['precos']['gasolina'][_selectedItem!.toLowerCase()].toString();
                      });
                    }
                  } catch (e) {
                    setState(() {
                      preco = 'Ocorreu um erro na busca do preço';
                    });
                  }
                }
              },
              ),
              Text(preco != "" ? 'A gasolina em sua localização custa em média R\$$preco' : "", style: TextStyle(fontSize: 30.0), textAlign: TextAlign.center, )
              ],
          ),
        ),
      ),
    );
  }
}
