import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: CalculatorUI(),
    );
  }
}

class CalculatorUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          width: 350, // Fixed width for the calculator
          height: 600, // Fixed height for the calculator
          child: Column(
            children: [
              // Display section
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("225×2",
                          style: TextStyle(color: Colors.orange, fontSize: 28)),
                      Text("450",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              // Buttons section
              Expanded(
                flex: 5,
                child: GridView.count(
                  crossAxisCount: 4,
                  padding: EdgeInsets.all(10),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children:
                      buttons.map((label) => CalculatorButton(label)).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String label;

  CalculatorButton(this.label);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Button click event
      },
      child: Container(
        decoration: BoxDecoration(
          color: isOperator(label) ? Colors.orange : Colors.grey[850],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  bool isOperator(String label) {
    return ['C', '÷', '×', '-', '+', '='].contains(label);
  }
}

const List<String> buttons = [
  'C',
  '+/-',
  '%',
  '÷',
  '7',
  '8',
  '9',
  '×',
  '4',
  '5',
  '6',
  '-',
  '1',
  '2',
  '3',
  '+',
  '0',
  '⌫',
  '.',
  '='
];
