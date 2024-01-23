import 'package:flutter/material.dart';
import 'package:vricalc/button_values.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = '';
  String operand = '';
  String number2 = '';
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Output
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '$number1$operand$number2'.isEmpty
                        ? '0'
                        : '$number1$operand$number2',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),

            // Buttons
            Wrap(
              children: Btn.buttonValues
                  .map((value) => SizedBox(
                        width: value == Btn.n0
                            ? screenSize.width / 2
                            : (screenSize.width / 4),
                        height: screenSize.width / 5,
                        child: buildButton(value),
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white24,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Assigning button colors
  Color getBtnColor(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.blueGrey
        : [
            Btn.per,
            Btn.multiply,
            Btn.add,
            Btn.subtract,
            Btn.divide,
            Btn.calculate
          ].contains(value)
            ? Colors.orange
            : Colors.black87;
  }

  //Functionality

  //User inputs
  void appendValue(String value) {
    // TODO: Handle negative numbers properly
    //condition for operand
    if (value != Btn.dot && int.tryParse(value) == null) {
      //condition for continued calculation with operands
      if (operand.isNotEmpty && number2.isNotEmpty) {
        calculate();
      }
      operand = value;

      //Assign number1
    } else if (number1.isEmpty || operand.isEmpty) {
      //conditions for decimals starting with a '0' for number1
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
        value = '0.';
      }
      number1 += value;

      //Assign number2
    } else if (number2.isEmpty || operand.isNotEmpty) {
      //conditions for decimals starting with a '0' for number2
      if (value == Btn.dot && number2.contains(Btn.dot)) return;
      if (value == Btn.dot && (number2.isEmpty || number2 == Btn.n0)) {
        value = '0.';
      }
      number2 += value;
    }

    setState(() {});
  }

  //Calculate the result
  void calculate() {
    //Check for inputs
    if (number1.isEmpty || operand.isEmpty || number2.isEmpty) return;

    double num1 = double.parse(number1);
    double num2 = double.parse(number2);

    var result = 0.0;

    switch (operand) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.divide:
        result = num1 / num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      default:
    }

    setState(() {
      number1 = '$result';

      //Unnecessary decimal to whole number
      if (number1.endsWith('.0')) {
        number1 = number1.substring(0, number1.length - 2);
      }

      //Reset inputs
      operand = '';
      number2 = '';
      //Condition to reset number1 so
      //continued use doesn't result in i.e: "05+10"
      if (number1 == '0') {
        number1 = '';
      }
    });
  }

  //Clear all inputs
  void clearAll() {
    setState(() {
      number1 = '';
      operand = '';
      number2 = '';
    });
  }

  //Convert input or result to percentage
  void convertToPercentage() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {}

    //Condition for no conversion
    if (operand.isNotEmpty) {
      return;
    }

    final number = double.parse(number1);
    setState(() {
      number1 = '${(number / 100)}';
      operand = '';
      number2 = '';
    });
  }

  //Delete as in backspace
  void delete() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = '';
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }

    setState(() {});
  }

  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }

    if (value == Btn.clr) {
      clearAll();
      return;
    }

    if (value == Btn.per) {
      convertToPercentage();
      return;
    }

    if (value == Btn.calculate) {
      calculate();
      return;
    }

    appendValue(value);
  }
}
