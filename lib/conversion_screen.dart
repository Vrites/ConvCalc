import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vricalc/button_values.dart';

class ConversionScreen extends StatefulWidget {
  const ConversionScreen({super.key});

  @override
  State<ConversionScreen> createState() => _ConversionScreenState();
}

class _ConversionScreenState extends State<ConversionScreen> {
  String number1 = '';
  String dropdownValue1 = '';
  String dropdownValue2 = '';
  bool firstExists = false;
  final List<String> dropdownItems = <String>[
    'Foot',
    'Mile',
    'Meter',
    'Kilometer',
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Convert buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: DropdownMenu<String>(
                    initialSelection: dropdownItems.first,
                    onSelected: (String? value) {
                      setState(() {
                        dropdownValue1 = value!;
                      });
                    },
                    dropdownMenuEntries: dropdownItems
                        .map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList(),
                  ),
                ),
                const Icon(Icons.arrow_right),
                Center(
                  child: DropdownMenu<String>(
                    initialSelection: dropdownItems.first,
                    onSelected: (String? value) {
                      setState(() {
                        dropdownValue2 = value!;
                      });
                    },
                    dropdownMenuEntries: dropdownItems
                        .map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList(),
                  ),
                ),
              ],
            ),
            // Output
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    number1,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),

            // Input Buttons
            Wrap(
              children: Btn.convButtonValues
                  .map((value) => SizedBox(
                        width: screenSize.width / 3,
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
    //Assign number1
    //conditions for decimals starting with a '0' for number1
    if (value == Btn.dot && number1.contains(Btn.dot)) return;
    if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
      value = '0.';
    }
    number1 += value;

    setState(() {});
  }

  //Calculate the result
  void calculate() {
    //Check for inputs
    if (number1.isEmpty) return;
    log('$dropdownValue1, $dropdownValue2');
    double num1 = double.parse(number1);
    double conversionRate = 0.0;
    bool leftToRight = true;
    var result = 0.0;

    //TODO: fix this clowning someday
    if (dropdownValue1 == 'Foot' && dropdownValue2 == 'Meter') {
      conversionRate = 3.281;
      leftToRight = false;
    }
    if (dropdownValue1 == 'Meter' && dropdownValue2 == 'Foot') {
      conversionRate = 3.281;
      leftToRight = true;
    }
    if (dropdownValue1 == 'Mile' && dropdownValue2 == 'Kilometer') {
      conversionRate = 1.6;
      leftToRight = false;
    }
    if (dropdownValue1 == 'Kilometer' && dropdownValue2 == 'Mile') {
      conversionRate = 1.6;
      leftToRight = true;
    }
    if (dropdownValue1 == dropdownValue2) return;

    if (leftToRight) {
      result = num1 * conversionRate;
    } else {
      result = num1 / conversionRate;
    }

    setState(() {
      number1 = '$result';

      //Unnecessary decimal to whole number
      if (number1.endsWith('.0')) {
        number1 = number1.substring(0, number1.length - 2);
      }
    });
  }

  //Clear all inputs
  void clearAll() {
    setState(() {
      number1 = '';
    });
  }

  void onBtnTap(String value) {
    if (value == Btn.clr) {
      clearAll();
      return;
    }

    if (value == Btn.calculate) {
      calculate();
      return;
    }

    appendValue(value);
  }
}
