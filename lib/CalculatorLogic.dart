class CalculatorLogic {
  String _output = "0";
  String _expression = "";

  String get output => _output;
  String get expression => _expression;

  void buttonPressed(String value) {
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
  }

  String _evaluateExpression(String expression) {
    try {
      // Ifodani to'g'ri formatlash: "×" va "÷" ni "*" va "/" ga almashtirish
      expression = expression.replaceAll("×", "*").replaceAll("÷", "/");

      // Ifodani tekshirish (faqat raqamlar, operatorlar va nuqta mavjud bo'lishi kerak)
      if (expression.isEmpty ||
          !RegExp(r'^[\d+\-*/().]+$').hasMatch(expression)) {
        return "Error"; // Noto'g'ri ifoda bo'lsa Error qaytarish
      }

      // Ifodani hisoblash uchun eval ishlatish
      // Agar eval ishlatilmayapti deb xato bersa, matematik operatsiyalarni bajaring
      final result = _performCalculation(expression);
      if (result == null) {
        return "Error"; // Xatolik yuzaga kelsa Error qaytarish
      }

      // Natijani formatlash
      return result.toStringAsFixed(2).replaceAll(RegExp(r'\.0+$'), '');
    } catch (e) {
      return "Error"; // Xatolik yuzaga kelsa Error qaytarish
    }
  }

  // Oddiy matematik ifodalarni hisoblash
  double? _performCalculation(String expression) {
    try {
      // Matematik amallarni qo'llash
      final result = _parseExpression(expression);
      return result;
    } catch (e) {
      return null;
    }
  }

  // Ifodani numerik qiymatga o'zgartirish
  double _parseExpression(String expression) {
    // Ifodani to'g'ri pars qilish
    final parsed = expression.replaceAll('*', '×').replaceAll('/', '÷');
    final result = double.tryParse(parsed);
    if (result == null) {
      throw FormatException("Invalid expression");
    }
    return result;
  }
}
