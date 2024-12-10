import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _output = '0';
  bool _isResultDisplayed = false;

  void _buttonPressed(String label) {
    setState(() {
      if (label == 'C') {
        _clear();
      } else if (label == '±') {
        _toggleSign();
      } else if (label == '%') {
        _percent();
      } else if (label == '=') {
        _calculate();
      } else if (label == '←') {
        _backspace();
      } else {
        _updateExpression(label);
      }
    });
  }

  void _clear() {
    _expression = '';
    _output = '0';
    _isResultDisplayed = false;
  }

  void _toggleSign() {
    if (_output != '0') {
      if (_output.startsWith('-')) {
        _output = _output.substring(1);
      } else {
        _output = '-' + _output;
      }
      _expression = _output;
    }
  }

  void _percent() {
    if (_output != '0') {
      double result = (double.tryParse(_output) ?? 0) / 100.0;
      _output = result.toString();
      _expression = _output;
    }
  }

  void _calculate() {
    try {
      Parser parser = Parser();
      Expression expression =
          parser.parse(_expression.replaceAll('×', '*').replaceAll('÷', '/'));
      double result = expression.evaluate(EvaluationType.REAL, ContextModel());

      _output = _formatResult(result);
      _expression = _output;
      _isResultDisplayed = true;
    } catch (e) {
      _output = 'Error';
    }
  }

  void _backspace() {
    if (_isResultDisplayed) {
      setState(() {
        _expression = _output;
        _isResultDisplayed = false;
      });
    }

    if (_expression.isNotEmpty) {
      _expression = _expression.substring(0, _expression.length - 1);
      if (_expression.isEmpty) {
        _output = '0';
      } else {
        _output = _expression;
      }
    }
  }

  void _updateExpression(String label) {
    if (_isResultDisplayed && RegExp(r'[0-9]').hasMatch(label)) {
      _clear();
    }
    if (_isResultDisplayed && RegExp(r'[+\-×÷]').hasMatch(label)) {
      _isResultDisplayed = false;
    }

    if (_expression.isNotEmpty &&
        RegExp(r'[+\-×÷]').hasMatch(_expression[_expression.length - 1]) &&
        RegExp(r'[+\-×÷]').hasMatch(label)) {
      _expression = _expression.substring(0, _expression.length - 1) + label;
    } else if (label == '%') {
      RegExp regex = RegExp(r'(\d+\.?\d*)$');
      Match? match = regex.firstMatch(_expression);

      if (match != null) {
        String numberStr = match.group(0)!;
        double number = double.parse(numberStr);

        double percentValue = number / 100;
        _expression =
            _expression.replaceAll(numberStr, percentValue.toString());
      }
    } else {
      if (_expression == '0' && RegExp(r'[0-9]').hasMatch(label)) {
        _expression = label;
      } else {
        _expression += label;
      }
    }
    _output = _expression;
  }

  String _formatResult(double result) {
    if (result == result.toInt()) {
      return result.toInt().toString();
    } else {
      return result.toStringAsFixed(2);
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
        margin: const EdgeInsets.all(4),
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
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
                    style: const TextStyle(
                        fontSize: 48, fontWeight: FontWeight.w300),
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
