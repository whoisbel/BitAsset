import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitset/controllers/historical_controller.dart';

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final HistoricalController controller = Get.put(HistoricalController());
  TextEditingController investmentController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController cryptoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 44, 45, 44),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: investmentController,
                keyboardType: TextInputType.number,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.normal),
                decoration: InputDecoration(
                  labelText: 'Initial Investment Amount',
                  labelStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: dateController,
                keyboardType: TextInputType.datetime,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.normal),
                decoration: InputDecoration(
                  labelText: 'Investment Date (e.g., 1-1-2014)',
                  labelStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: cryptoController,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.normal),
                decoration: InputDecoration(
                  labelText: 'Cryptocurrency',
                  labelStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                calculateProfitLoss();
              },
              child: Text('Calculate'),
            ),
            Obx(
              () {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (controller.historicalModel.value == null) {
                  return Center(
                    child: Text(
                      'Failed to load data',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  void calculateProfitLoss() {
    double initialInvestment =
        double.tryParse(investmentController.text) ?? 0.0;

    if (controller.historicalModel.value != null) {
      double historicalPrice =
          controller.historicalModel.value!.marketData.currentPrice['usd'] ??
              0.0;
      double currentInvestmentValue = initialInvestment * historicalPrice;

      double profitOrLoss = currentInvestmentValue - initialInvestment;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profit/Loss: \$${profitOrLoss.toStringAsFixed(2)}'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Failed to calculate profit/loss. Please try again later.'),
        ),
      );
    }
  }
}
