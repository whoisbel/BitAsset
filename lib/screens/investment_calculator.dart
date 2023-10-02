import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitset/controllers/historical_controller.dart';
import 'package:bitset/controllers/crypto_controller.dart';
import 'package:intl/intl.dart';

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
  final value = new NumberFormat("#,##0.00", "en_US");
  String result = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 44, 45, 44),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                Text(
                  'Crypto Investment Calculator',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                _buildInputField(
                  controller: investmentController,
                  label: 'Initial Investment Amount',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                _buildInputField(
                  controller: dateController,
                  label: 'Investment Date (e.g., 1-1-2014)',
                  keyboardType: TextInputType.datetime,
                ),
                SizedBox(height: 20),
                _buildInputField(
                  controller: cryptoController,
                  label: 'Cryptocurrency name (e.g., ethereum)',
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    calculateProfitLoss();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                  ),
                  child: Text('Calculate'),
                ),
                SizedBox(height: 20),
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
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        result ?? "",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.normal,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.normal,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
      ),
    );
  }

  void calculateProfitLoss() async {
    double initialInvestment =
        double.tryParse(investmentController.text) ?? 0.0;
    String investmentDate = dateController.text;
    String selectedCrypto = cryptoController.text;
    bool isError = false;
    if (selectedCrypto.isNotEmpty) {
      try {
        await controller.fetchHistoricalData(selectedCrypto, investmentDate);
        double pastPrice =
            controller.historicalModel.value!.marketData.currentPrice['usd'] ??
                0;
        if (controller.historicalModel.value!.marketData.currentPrice['usd'] ==
            null) {
          print("Error loading that cryptocurrency data");
        } else {
          double pastQuantity = initialInvestment / pastPrice;
          double currentValue = pastQuantity * _getPrice();
          result =
              "If you invested \$$initialInvestment in $selectedCrypto on $investmentDate, its value today would be \$${value.format(currentValue)}";
        }
      } catch (e) {
        result = "";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid name/date, try inserting a later date.'),
          ),
        );
        isError = true;
        return;
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
