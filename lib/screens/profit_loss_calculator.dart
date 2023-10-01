import 'package:bitset/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitset/controllers/historical_controller.dart';
import 'package:bitset/controllers/crypto_controller.dart';

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final HistoricalController controller = Get.put(HistoricalController());
  final CryptoController cController = Get.put(CryptoController());
  TextEditingController investmentController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController cryptoController = TextEditingController();
  String result = "";
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
                return Text(
                  result ?? "",
                  style: textStyle(16, Colors.white, FontWeight.normal),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void calculateProfitLoss() async {
    double initialInvestment =
        double.tryParse(investmentController.text) ?? 0.0;
    String investmentDate = dateController.text;
    String selectedCrypto = cryptoController.text;

    if (selectedCrypto.isNotEmpty) {
      await controller.fetchHistoricalData(selectedCrypto, investmentDate);
      double pastPrice =
          controller.historicalModel.value!.marketData.currentPrice['usd'] ?? 0;
      if (controller.historicalModel.value!.marketData.currentPrice['usd'] ==
          null) {
        print("Error loading that cryptocurrency data");
      } else {
        double pastQuantity = initialInvestment / pastPrice;
        double currentValue = pastQuantity * _getPrice();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Current value: $currentValue'),
          ),
        );
        result =
            "If you invested \$$initialInvestment in $selectedCrypto on $investmentDate, its value today would be \$${currentValue.toStringAsFixed(2)}";
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a cryptocurrency symbol.'),
        ),
      );
    }
  }

  double _getPrice() {
    String name = cryptoController.text;
    for (int i = 0; i < cController.cryptoList.length; i++) {
      if (name == cController.cryptoList[i].name.toLowerCase()) {
        return cController.cryptoList[i].currentPrice;
      }
    }
    return 0;
  }
}
