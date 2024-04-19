import 'package:calc_app/models/data.dart';
import 'package:calc_app/widgets/my_font.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = "";
  String operand = "";
  String number2 = "";

  Color? color;
  Color getBtnColor(btn) {
    switch (btn) {
      case "AC":
      case "+/-":
      case "%":
        color = Colors.grey.shade400;
        break;
      case "÷":
      case "x":
      case "-":
      case "+":
      case "=":
        color = Colors.amber.shade700;
        break;

      default:
        color = Colors.grey.shade900;
    }
    return color!;
  }

  void onBtnTapped(String btn) {
    if (btn == Btn.clr) {
      clear(btn);
      return;
    }

    if (btn == Btn.per) {
      convertToPercentage();
      return;
    }

    if (btn == Btn.equal) {
      calculate(btn);
    }

    if (btn == Btn.minus) {
      toMinus();
      return;
    }

    appendValue(btn);
  }

  //##########
  void appendValue(String btn) {
    //operand pressed
    if (btn != Btn.dot && int.tryParse(btn) == null) {
      //checking if we have an equation already if its then calculate
      if (operand.isNotEmpty && number2.isNotEmpty) {
        //TO-DO calculate
      }

      btn == Btn.equal ? operand = "" : operand = btn;

      //Working with number1
    } else if (number1.isEmpty || operand.isEmpty) {
      //check if number1 has dot already if its nothing to do
      if (btn == Btn.dot && number1.contains(Btn.dot)) return;
      //if the user taps dot first just show "0." instead "."
      if (btn == Btn.dot && (number1.isEmpty || number1 == Btn.dot)) {
        btn = "0.";
      }

      //if user taps 0 first then we don't append it
      btn == Btn.n0 && number1.isEmpty ? number1 == "" : number1 += btn;

      //Working with number2
    } else if (number2.isEmpty || operand.isNotEmpty) {
      //check if number2 has dot already if its nothing to do
      if (btn == Btn.dot && number2.contains(Btn.dot)) return;
      //if the user taps dot first just show "0." instead "."
      if (btn == Btn.dot && (number2.isEmpty || number2 == Btn.dot)) {
        btn = "0.";
      }

      number2 += btn;
    }

    setState(() {});
  }

  //############
  void clear(String btn) {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

  //###########
  void convertToPercentage() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      //calculate b/f conversion
      //TO-Do
    }

    if (operand.isNotEmpty) {
      //cannot be converted
      return;
    }

    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operand = "";
      number2 = "";
      
    });
  }

  //#########
  void calculate(String btn) {
    //if one of them is empty we cannot calculate
    if (number1.isEmpty) return;
    if (number2.isEmpty) return;
    if (operand.isEmpty) return;

    double result = 0;

    switch (operand) {
      case Btn.add:
        result = double.parse(number1) + double.parse(number2);
        break;
      case Btn.substract:
        result = double.parse(number1) - double.parse(number2);
        break;
      case Btn.multiply:
        result = double.parse(number1) * double.parse(number2);
        break;
      case Btn.divide:
        result = double.parse(number1) / double.parse(number2);
        break;
    }

    setState(() {
      number1 = "$result";
      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }

      operand = "";
      number2 = "";
    });
  }

  //#############
  void toMinus() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      //we cannot convert to minus b/f calculation
      return;
    }

    if (number1.isNotEmpty && (number2.isEmpty || operand.isEmpty)) {
      //now we can convert to minus
      setState(() {
        number1 = "-$number1";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            //output
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(
                        top: screenSize.height * .25, right: 20, bottom: 20),
                    child: MyFont(
                        text: "$number1$number2$operand".isEmpty
                            ? "0"
                            : "$number1$operand$number2",
                        fontSize: 40)),
              ),
            ),

            //buttons
            Wrap(
              children: Btn.buttonValues
                  .map((btn) => Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: SizedBox(
                            width: btn == Btn.n0
                                ? screenSize.width / 2
                                : screenSize.width / 4,
                            height: screenSize.width / 5,
                            child: buildButton(btn)),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(btn) {
    return Center(
        child: GestureDetector(
      onTap: () => onBtnTapped(btn),
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 700),
          alignment: btn != Btn.n0 ? Alignment.center : Alignment.topLeft,
          height: 120,
          width: btn == Btn.n0 ? 200 : 100,
          margin: EdgeInsets.only(left: btn == Btn.n0 ? 10 : 0),
          padding: EdgeInsets.only(
              left: btn == Btn.n0 ? 30 : 0, top: btn == Btn.n0 ? 15 : 0),
          decoration: BoxDecoration(
              borderRadius: btn == Btn.n0 ? BorderRadius.circular(100) : null,
              shape: btn == Btn.n0 ? BoxShape.rectangle : BoxShape.circle,
              color: getBtnColor(btn)),
          child: MyFont(
            text: btn,
            fontSize: 32,
            fontWeight: FontWeight.w500,
            color: btn == "AC"
                ? Colors.black
                : btn == "+/-"
                    ? Colors.black
                    : btn == "%"
                        ? Colors.black
                        : Colors.white,
          )),
    ));
  }
}
