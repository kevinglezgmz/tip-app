import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum RadioValues {
  amazing,
  good,
  okay;

  double get multiplier {
    if (name == 'amazing') {
      return 0.20;
    } else if (name == 'good') {
      return 0.18;
    } else {
      return 0.15;
    }
  }
}

class _HomeScreenState extends State<HomeScreen> {
  var costController = TextEditingController();
  RadioValues selectedTipRadio = RadioValues.okay;
  bool shouldRoundTipUp = true;
  double totalTip = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tip Time'),
      ),
      body: ListView(
        children: [
          Container(
            height: 16,
          ),
          ListTile(
            leading: const Icon(Icons.store),
            title: Padding(
              padding: const EdgeInsets.only(right: 100),
              child: TextField(
                controller: costController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  label: Text("Cost of service"),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.room_service),
            title: Text('How was the service?'),
          ),
          getTipRadioRow('Amazing (20%)', RadioValues.amazing),
          getTipRadioRow('Good (18%)', RadioValues.good),
          getTipRadioRow('Okay (15%)', RadioValues.okay),
          ListTile(
            leading: const Icon(Icons.call_made_outlined),
            title: Row(
              children: [
                const Text('Round up tip?'),
                const Spacer(),
                Switch(
                  value: shouldRoundTipUp,
                  onChanged: (newValue) {
                    setState(() {
                      shouldRoundTipUp = newValue;
                    });
                  },
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 64, right: 30),
            child: MaterialButton(
              color: Colors.green[900],
              onPressed: _tipCalculation,
              child: const Text(
                'CALCULATE',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 14, right: 30),
            child: Text(
              'Tip Amount: \$${totalTip.toStringAsFixed(2)}',
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  RadioListTile getTipRadioRow(String radioText, RadioValues radioGroupValue) {
    return RadioListTile<RadioValues>(
      contentPadding: const EdgeInsets.only(left: 64),
      title: Text(radioText),
      value: radioGroupValue,
      groupValue: selectedTipRadio,
      onChanged: (radioValue) {
        setState(() {
          if (radioValue != null) {
            selectedTipRadio = radioValue;
          }
        });
      },
    );
  }

  void _tipCalculation() {
    double? maybeTotalCost = double.tryParse(costController.text);
    if (maybeTotalCost == null) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Cost of service'),
          content: const Text('Please enter a valid cost of service.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
    double totalCost = maybeTotalCost;
    double multiplier = selectedTipRadio.multiplier;
    setState(() {
      if (shouldRoundTipUp) {
        totalTip = (multiplier * totalCost).ceilToDouble();
      } else {
        totalTip = multiplier * totalCost;
      }
    });
  }
}
