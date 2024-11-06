import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: CalculatorPage(),
  ));
}

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final TextEditingController number1Controller = TextEditingController();
  final TextEditingController number2Controller = TextEditingController();
  double? result;

  void _calculateSum() {
    double number1 = double.tryParse(number1Controller.text) ?? 0;
    double number2 = double.tryParse(number2Controller.text) ?? 0;
    setState(() {
      result = number1 + number2;
    });
  }

  void _calculateDifference() {
    double number1 = double.tryParse(number1Controller.text) ?? 0;
    double number2 = double.tryParse(number2Controller.text) ?? 0;
    setState(() {
      result = number1 - number2;
    });
  }

  void _calculateProduct() {
    double number1 = double.tryParse(number1Controller.text) ?? 0;
    double number2 = double.tryParse(number2Controller.text) ?? 0;
    setState(() {
      result = number1 * number2;
    });
  }

  void _calculateDivision() {
    double number1 = double.tryParse(number1Controller.text) ?? 0;
    double number2 = double.tryParse(number2Controller.text) ?? 1; // Bölme sıfıra bölünmeyi önlemek için 1 olarak ayarlandı
    if (number2 == 0) {
      setState(() {
        result = double.infinity; // Sıfıra bölme için ∞ sonucu gösterir
      });
    } else {
      setState(() {
        result = number1 / number2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: Text("Hesaplayıcı"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: number1Controller,
              decoration: InputDecoration(labelText: "Birinci Sayı"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: number2Controller,
              decoration: InputDecoration(labelText: "İkinci Sayı"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _calculateSum,
                  child: Text("Topla"),
                ),
                ElevatedButton(
                  onPressed: _calculateDifference,
                  child: Text("Çıkar"),
                ),
                ElevatedButton(
                  onPressed: _calculateProduct,
                  child: Text("Çarp"),
                ),
                ElevatedButton(
                  onPressed: _calculateDivision,
                  child: Text("Böl"),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (result != null)
              Text(
                "Sonuç: $result",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
