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
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0";
  String _expression = "";

  void _buttonPressed(String value) {
    setState(() {
      if (value == "=") {
        try {
          _output = _evaluateExpression(_expression);
          _expression = _output;
        } catch (e) {
          _output = "Error";
        }
      } else if (value == "C") {
        _expression = "";
        _output = "0";
      } else if (value == "←") {
        _expression = _expression.isNotEmpty
            ? _expression.substring(0, _expression.length - 1)
            : "";
        _output = _expression.isNotEmpty ? _expression : "0";
      } else {
        _expression += value;
        _output = _expression;
      }
    });
  }

  String _evaluateExpression(String expression) {
    try {
      final result = expression.replaceAll("×", "*").replaceAll("÷", "/");
      final double eval = double.parse(result); // Replace with a proper parser.
      return eval.toStringAsFixed(2).replaceAll(RegExp(r'\.0+$'), '');
    } catch (e) {
      return "Error";
    }
  }

  Widget _buildButton(String label,
      {Color? backgroundColor, Color? textColor, double? fontSize}) {
    return GestureDetector(
      onTap: () => _buttonPressed(label),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.all(4),
        child: Text(
          label,
          style: TextStyle(
            fontSize: fontSize ?? 16,
            fontWeight: FontWeight.w400,
            color: textColor ?? Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonLabels = [
      "C",
      "±",
      "%",
      "÷",
      "7",
      "8",
      "9",
      "×",
      "4",
      "5",
      "6",
      "-",
      "1",
      "2",
      "3",
      "+",
      "0",
      "←",
      ".",
      "="
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _expression,
                    style: TextStyle(fontSize: 30, color: Colors.orange[300]),
                  ),
                  Text(
                    _output,
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 2,
            color: Colors.orange,
            margin: const EdgeInsets.symmetric(vertical: 10),
          ),
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.grey[900],
              child: GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: (screenWidth / 2) / (screenHeight / 4),
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                ),
                itemCount: buttonLabels.length,
                itemBuilder: (context, index) {
                  final label = buttonLabels[index];
                  final isOperator = ["÷", "×", "-", "+"].contains(label);
                  final isEqual = label == "=";

                  return _buildButton(
                    label,
                    backgroundColor: isOperator
                        ? Colors.grey
                        : isEqual
                            ? Colors.orange
                            : Colors.transparent,
                    textColor:
                        isOperator || isEqual ? Colors.black : Colors.white,
                    fontSize: isOperator || isEqual ? 28 : 24,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
