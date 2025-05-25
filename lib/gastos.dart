import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class TelaRegistroGastos extends StatefulWidget {
  final ThemeMode tema;
  final VoidCallback trocarTema;
  final Icon iconeDefault;

  const TelaRegistroGastos({
    super.key,
    required this.tema,
    required this.trocarTema,
    required this.iconeDefault,
  });

  @override
  State<TelaRegistroGastos> createState() => _TelaRegistroGastosState();
}

class FuelExpense {
  final double amount;
  final DateTime date;

  FuelExpense({required this.amount, required this.date});

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'date': date.toIso8601String(),
  };

  factory FuelExpense.fromJson(Map<String, dynamic> json) =>
      FuelExpense(amount: json['amount'], date: DateTime.parse(json['date']));
}

class _TelaRegistroGastosState extends State<TelaRegistroGastos> {
  List<FuelExpense> _expenses = [];
  final _amountController = TextEditingController();
  final _currencyFormatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );
  DateTime _selectedDate = DateTime.now();
  String _selectedPeriod = 'Mês';

  bool get modoEscuro => widget.tema == ThemeMode.dark;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
    _amountController.addListener(_onAmountChanged);
  }

  @override
  void dispose() {
    _amountController.removeListener(_onAmountChanged);
    _amountController.dispose();
    super.dispose();
  }

  void _onAmountChanged() {
    String text = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (text.isEmpty) text = '0';
    double value = double.parse(text) / 100;
    String newText = _currencyFormatter.format(value);
    if (_amountController.text != newText) {
      _amountController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }
  }

  double _parseCurrency(String text) {
    String cleaned = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.isEmpty) return 0.0;
    return double.parse(cleaned) / 100;
  }

  Future<void> _loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('expenses');
    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);
      setState(() {
        _expenses = jsonList.map((json) => FuelExpense.fromJson(json)).toList();
      });
    }
  }

  Future<void> _saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _expenses.map((e) => e.toJson()).toList();
    await prefs.setString('expenses', jsonEncode(jsonList));
  }

  void _addExpense() {
    final amount = _parseCurrency(_amountController.text);
    if (amount > 0) {
      setState(() {
        _expenses.add(FuelExpense(amount: amount, date: _selectedDate));
        _amountController.clear();
        _selectedDate = DateTime.now();
      });
      _saveExpenses();
    }
  }

  List<FuelExpense> _filteredExpenses() {
    DateTime now = DateTime.now();
    if (_selectedPeriod == 'Semana') {
      DateTime weekStart = now.subtract(Duration(days: now.weekday - 1));
      return _expenses
          .where(
            (e) =>
                e.date.isAfter(weekStart.subtract(Duration(days: 1))) &&
                e.date.isBefore(weekStart.add(Duration(days: 7))),
          )
          .toList();
    } else if (_selectedPeriod == 'Mês') {
      return _expenses
          .where((e) => e.date.year == now.year && e.date.month == now.month)
          .toList();
    } else if (_selectedPeriod == 'Ano') {
      return _expenses.where((e) => e.date.year == now.year).toList();
    }
    return _expenses;
  }

  List<BarChartGroupData> _buildChartData() {
    final filtered = _filteredExpenses();
    Map<int, double> grouped = {};

    if (_selectedPeriod == 'Semana') {
      for (var e in filtered) {
        int idx = e.date.weekday % 7;
        grouped[idx] = (grouped[idx] ?? 0) + e.amount;
      }
      final bars = List.generate(7, (i) {
        double y = grouped[i] ?? 0;
        return BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: y,
              color: Color.fromARGB(255, 37, 136, 96),
              width: 18,
              borderRadius: BorderRadius.circular(4),
              rodStackItems: [],
            ),
          ],
          showingTooltipIndicators: [],
        );
      });
      if (bars.every((bar) => bar.barRods.first.toY == 0)) return [];
      return bars;
    } else if (_selectedPeriod == 'Mês') {
      for (var e in filtered) {
        grouped[e.date.day] = (grouped[e.date.day] ?? 0) + e.amount;
      }
      final daysWithExpense = grouped.keys.toList()..sort();
      final bars =
          daysWithExpense.map((day) {
            double y = grouped[day] ?? 0;
            return BarChartGroupData(
              x: day,
              barRods: [
                BarChartRodData(
                  toY: y,
                  color: Color.fromARGB(255, 37, 136, 96),
                  width: 18,
                  borderRadius: BorderRadius.circular(4),
                  rodStackItems: [],
                ),
              ],
              showingTooltipIndicators: [],
            );
          }).toList();
      if (bars.isEmpty) return [];
      return bars;
    } else if (_selectedPeriod == 'Ano') {
      for (var e in filtered) {
        grouped[e.date.month] = (grouped[e.date.month] ?? 0) + e.amount;
      }
      final bars = List.generate(12, (i) {
        double y = grouped[i + 1] ?? 0;
        return BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: y,
              color: Color.fromARGB(255, 37, 136, 96),
              width: 18,
              borderRadius: BorderRadius.circular(4),
              rodStackItems: [],
            ),
          ],
          showingTooltipIndicators: [],
        );
      });
      if (bars.every((bar) => bar.barRods.first.toY == 0)) return [];
      return bars;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final chartData = _buildChartData();
    final filtered = _filteredExpenses();
    final total = filtered.fold<double>(0, (sum, e) => sum + e.amount);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: widget.trocarTema, icon: widget.iconeDefault),
        ],
        toolbarHeight: 110,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: modoEscuro ? Colors.white : Colors.black,
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Registrar gasto",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: 'Valor do gasto',
                      labelStyle: TextStyle(
                        color: modoEscuro ? Colors.white : Colors.black,
                      ),
                      prefixIcon: Icon(
                        Icons.local_gas_station,
                        color: modoEscuro ? Colors.white : Colors.black,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: modoEscuro ? Colors.white : Colors.black,
                        ),
                      ),
                      filled: true,
                      fillColor:
                          modoEscuro
                              ? Color.fromARGB(255, 31, 31, 31)
                              : Color.fromARGB(247, 246, 244, 255),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 10,
                    ),
                    backgroundColor:
                        modoEscuro
                            ? const Color.fromARGB(255, 31, 31, 31)
                            : const Color.fromARGB(247, 246, 244, 255),
                    side: BorderSide(
                      color: modoEscuro ? Colors.white : Colors.black,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                  child: Text(
                    "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                    style: TextStyle(
                      color: modoEscuro ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 10,
                    ),
                    backgroundColor:
                        modoEscuro
                            ? const Color.fromARGB(255, 31, 31, 31)
                            : const Color.fromARGB(247, 246, 244, 255),
                    side: BorderSide(
                      color: modoEscuro ? Colors.white : Colors.black,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    final amount = _parseCurrency(_amountController.text);
                    if (amount <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Digite um valor válido!'),
                        ),
                      );
                      return;
                    }
                    _addExpense();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gasto adicionado!')),
                    );
                  },
                  child: Text(
                    'Adicionar',
                    style: TextStyle(
                      color: modoEscuro ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Período:'),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedPeriod,
                  items:
                      ['Semana', 'Mês', 'Ano']
                          .map(
                            (p) => DropdownMenuItem(
                              value: p,
                              child: Text(
                                p,
                                style: TextStyle(
                                  color:
                                      modoEscuro ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (v) {
                    setState(() {
                      _selectedPeriod = v!;
                    });
                  },
                  dropdownColor:
                      modoEscuro
                          ? Color.fromARGB(255, 31, 31, 31)
                          : Color.fromARGB(247, 246, 244, 255),
                ),
                const Spacer(),
                Text(
                  "Total: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(total)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              flex: 2,
              child:
                  chartData.isEmpty
                      ? const Center(
                        child: Text('Sem dados para o período selecionado.'),
                      )
                      : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: BarChart(
                          BarChartData(
                            barGroups: chartData,
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              getDrawingHorizontalLine:
                                  (value) => FlLine(
                                    color: Colors.grey,
                                    strokeWidth: 0.5,
                                  ),
                            ),
                            borderData: FlBorderData(
                              show: true,
                              border: const Border(
                                left: BorderSide(color: Colors.black26),
                                bottom: BorderSide(color: Colors.black26),
                              ),
                            ),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 60,
                                  getTitlesWidget: (value, meta) {
                                    final maxY = chartData
                                        .map((e) => e.barRods.first.toY)
                                        .fold<double>(
                                          0,
                                          (prev, el) => el > prev ? el : prev,
                                        );
                                    final interval = (maxY / 4).ceilToDouble();
                                    if (value == 0 ||
                                        (interval > 0 &&
                                            value % interval == 0)) {
                                      final formatted = NumberFormat.currency(
                                        locale: 'pt_BR',
                                        symbol: 'R\$',
                                      ).format(value);
                                      return Text(
                                        formatted,
                                        style: const TextStyle(fontSize: 12),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    if (_selectedPeriod == 'Semana') {
                                      const days = [
                                        'Dom',
                                        'Seg',
                                        'Ter',
                                        'Qua',
                                        'Qui',
                                        'Sex',
                                        'Sáb',
                                      ];
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 4.0,
                                        ),
                                        child: Text(
                                          days[value.toInt() % 7],
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      );
                                    } else if (_selectedPeriod == 'Mês') {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 4.0,
                                        ),
                                        child: Text(
                                          '${value.toInt()}',
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      );
                                    } else if (_selectedPeriod == 'Ano') {
                                      const months = [
                                        'Jan',
                                        'Fev',
                                        'Mar',
                                        'Abr',
                                        'Mai',
                                        'Jun',
                                        'Jul',
                                        'Ago',
                                        'Set',
                                        'Out',
                                        'Nov',
                                        'Dez',
                                      ];
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 4.0,
                                        ),
                                        child: Text(
                                          months[value.toInt() % 12],
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      );
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            barTouchData: BarTouchData(
                              enabled: true,
                              touchTooltipData: BarTouchTooltipData(
                                tooltipBgColor: Color.fromARGB(
                                  255,
                                  37,
                                  136,
                                  96,
                                ),
                                getTooltipItem: (
                                  group,
                                  groupIndex,
                                  rod,
                                  rodIndex,
                                ) {
                                  final formatted = NumberFormat.currency(
                                    locale: 'pt_BR',
                                    symbol: 'R\$',
                                  ).format(rod.toY);
                                  return BarTooltipItem(
                                    formatted,
                                    const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                              handleBuiltInTouches: true,
                            ),
                            extraLinesData: ExtraLinesData(),
                            maxY:
                                chartData
                                    .map((e) => e.barRods.first.toY)
                                    .fold<double>(
                                      0,
                                      (prev, el) => el > prev ? el : prev,
                                    ) +
                                20,
                          ),
                        ),
                      ),
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Histórico de gastos",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Expanded(
              flex: 3,
              child:
                  filtered.isEmpty
                      ? const Center(child: Text('Nenhum gasto registrado.'))
                      : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          final e = filtered[filtered.length - 1 - i];
                          return Dismissible(
                            key: Key('${e.date.toIso8601String()}-${e.amount}'),
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 20),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            secondaryBackground: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (direction) {
                              setState(() {
                                _expenses.removeWhere(
                                  (exp) =>
                                      exp.amount == e.amount &&
                                      exp.date == e.date,
                                );
                              });
                              _saveExpenses();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Gasto removido!'),
                                ),
                              );
                            },
                            child: Card(
                              color:
                                  modoEscuro
                                      ? Color.fromARGB(255, 31, 31, 31)
                                      : Color.fromARGB(247, 246, 244, 255),
                              child: ListTile(
                                leading: Icon(
                                  Icons.local_gas_station,
                                  color:
                                      modoEscuro ? Colors.white : Colors.black,
                                ),
                                title: Text(
                                  NumberFormat.currency(
                                    locale: 'pt_BR',
                                    symbol: 'R\$',
                                  ).format(e.amount),
                                  style: TextStyle(
                                    color:
                                        modoEscuro
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                                subtitle: Text(
                                  '${e.date.day}/${e.date.month}/${e.date.year}',
                                  style: TextStyle(
                                    color:
                                        modoEscuro
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
