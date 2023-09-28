import 'package:flutter/material.dart';
import 'package:bitset/controllers/portfolio_controller.dart';
import 'package:bitset/model/portfolio_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bitset/utils.dart';
import 'package:bitset/controllers/crypto_controller.dart';
import 'package:get/get.dart';

class PortfolioViewPage extends StatefulWidget {
  final dynamic cryptoData;

  // Make cryptoData optional by providing a default value of null.
  PortfolioViewPage({Key? key, this.cryptoData}) : super(key: key);

  @override
  State<PortfolioViewPage> createState() => _PortfolioViewPageState();
}

class _PortfolioViewPageState extends State<PortfolioViewPage> {
  late PortfolioController _portfolioController;
  final CryptoController controller = Get.put(CryptoController());

  @override
  void initState() {
    super.initState();
    _initializePortfolioController();
  }

  void _initializePortfolioController() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final portfolioController = PortfolioController(prefs);

    setState(() {
      _portfolioController = portfolioController;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cryptoName = widget.cryptoData?.name ?? 'No Name';
    final cryptoSymbol = widget.cryptoData?.symbol ?? 'No Symbol';
    final cryptoPrice = widget.cryptoData?.currentPrice ?? 'No Price';
    TextEditingController asset = TextEditingController();

    if (cryptoName != 'No Name' || cryptoSymbol != "No Symbol") {
      return Scaffold(
        backgroundColor: Color.fromARGB(255, 44, 45, 44),
        body: AlertDialog(
          backgroundColor: Color.fromARGB(255, 44, 45, 44),
          title: const Text("Investment"),
          content: Column(
            children: [
              const Text("Enter the amount you want to invest:"),
              TextField(
                keyboardType: TextInputType.number, // Allow numeric input
                decoration: const InputDecoration(
                  hintText: "Enter amount",
                ),
                // You can capture the user's input using a TextEditingController
                controller: asset,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Access the user's input from the TextEditingController
                final double investmentAmount = double.parse(asset.text);
                // You can use the investmentAmount as needed
                _addAsset(cryptoName, cryptoSymbol.toString().toUpperCase(),
                    cryptoPrice, investmentAmount);
                print("User wants to invest: $investmentAmount");
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog without doing anything
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        ),
      );
    }
    if (_portfolioController == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 44, 45, 44),
        body: Column(
          children: [
            Expanded(
              child: _buildPortfolioList(),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildPortfolioList() {
    PortfolioModel? portfolioModel = _portfolioController.portfolioModel;

    if (portfolioModel != null) {
      return ListView.builder(
        itemCount: portfolioModel.assets.length,
        itemBuilder: (context, index) {
          final Asset asset = portfolioModel.assets[index];
          return ListTile(
            title: Text(asset.assetName,
                style: textStyle(MediaQuery.of(context).size.width * 0.035,
                    Colors.white, FontWeight.w600)),
            subtitle: Text('${asset.quantity} ${asset.tickerSymbol}',
                style: textStyle(MediaQuery.of(context).size.width * 0.035,
                    Colors.white, FontWeight.w600)),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('\$${asset.totalInvested}',
                    style: textStyle(MediaQuery.of(context).size.width * 0.035,
                        Colors.white, FontWeight.w600)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Button for buying more of the asset.
                        _showBuyDialog(asset);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Buy'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Button for selling the asset.
                        _showSellDialog(asset);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Sell'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    } else {
      return const Center(
        child: Text('No data available.'),
      );
    }
  }

  void _addAsset(String asset, String ticker, double price, double amount) {
    final String assetName = asset;
    final String tickerSymbol = ticker;
    final double quantity = amount / price;
    final double totalInvested = amount;

    if (assetName.isNotEmpty &&
        tickerSymbol.isNotEmpty &&
        quantity > 0 &&
        totalInvested > 0) {
      final Asset newAsset = Asset(
        assetName: assetName,
        tickerSymbol: tickerSymbol,
        quantity: quantity,
        totalInvested: totalInvested,
      );

      _portfolioController.addAsset(newAsset);

      setState(() {});
    } else {
      // Show an error message to the user if any field is empty or invalid.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid asset details.'),
        ),
      );
    }
  }

  void _showBuyDialog(Asset asset) {
    showDialog(
      context: context,
      builder: (context) {
        double quantity = 0;
        double totalInvested = 0;

        return AlertDialog(
          title: Text('Buy ${asset.assetName}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  quantity = double.tryParse(value) ?? 0;
                },
                decoration: const InputDecoration(labelText: 'Quantity'),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  totalInvested = double.tryParse(value) ?? 0;
                },
                decoration: const InputDecoration(labelText: 'Total Invested'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _buyAsset(asset, quantity, totalInvested);
                Navigator.of(context).pop();
              },
              child: const Text('Buy'),
            ),
          ],
        );
      },
    );
  }

  void _showSellDialog(Asset asset) {
    showDialog(
      context: context,
      builder: (context) {
        double quantity = 0;
        double totalInvested = 0;

        return AlertDialog(
          title: Text('Sell ${asset.assetName}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  quantity = double.tryParse(value) ?? 0;
                },
                decoration: const InputDecoration(labelText: 'Quantity'),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  totalInvested = double.tryParse(value) ?? 0;
                },
                decoration: const InputDecoration(labelText: 'Total Invested'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _sellAsset(asset, quantity, totalInvested);
                Navigator.of(context).pop();
              },
              child: const Text('Sell'),
            ),
          ],
        );
      },
    );
  }

  void _buyAsset(Asset asset, double quantity, double totalInvested) {
    if (quantity > 0 && totalInvested > 0) {
      final Asset updatedAsset = Asset(
        assetName: asset.assetName,
        tickerSymbol: asset.tickerSymbol,
        quantity: quantity,
        totalInvested: totalInvested,
      );

      _portfolioController.editAsset(updatedAsset, buy: true);

      // Trigger a rebuild of the widget.
      setState(() {});
    } else {
      // Show an error message to the user if the quantity or total investment is invalid.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Please enter a valid quantity and total invested amount.'),
        ),
      );
    }
  }

  void _sellAsset(Asset asset, double quantity, double totalInvested) {
    if (quantity > 0 && totalInvested > 0) {
      final double updatedQuantity = asset.quantity - quantity;
      final double updatedTotalInvested = asset.totalInvested - totalInvested;

      // Check if the updated quantity and total invested are both zero.
      if (updatedQuantity <= 0 || updatedTotalInvested <= 0) {
        // Remove the asset from the list if both quantity and total invested are zero or negative.
        _portfolioController.removeAsset(asset.tickerSymbol);
      } else {
        // Update the asset with the new quantity and total invested.
        final Asset updatedAsset = Asset(
          assetName: asset.assetName,
          tickerSymbol: asset.tickerSymbol,
          quantity: updatedQuantity,
          totalInvested: updatedTotalInvested,
        );

        _portfolioController.editAsset(updatedAsset, buy: false);
      }

      // Trigger a rebuild of the widget.
      setState(() {});
    } else {
      // Show an error message to the user if the quantity or total investment is invalid.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Please enter a valid quantity and total invested amount.'),
        ),
      );
    }
  }

  void _removeAsset(String tickerSymbol) {
    _portfolioController.removeAsset(tickerSymbol);

    // Trigger a rebuild of the widget.
    setState(() {});
  }

  double _getTotalInvest(PortfolioModel model) {
    double result = 0;
    for (var i = 0; i < model.assets.length; i++) {
      result += model.assets[i].totalInvested;
    }
    return result;
  }
}
