import 'package:flutter/material.dart';
import 'package:bitset/controllers/portfolio_controller.dart';
import 'package:bitset/model/portfolio_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bitset/utils.dart';

class PortfolioViewPage extends StatefulWidget {
  @override
  State<PortfolioViewPage> createState() => _PortfolioViewPageState();
}

class _PortfolioViewPageState extends State<PortfolioViewPage> {
  late PortfolioController _portfolioController;

  TextEditingController _assetNameController = TextEditingController();
  TextEditingController _tickerSymbolController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _totalInvestedController = TextEditingController();

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
    if (_portfolioController == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Color.fromARGB(255, 44, 45, 44),
        body: Column(
          children: [
            Expanded(
              child: _buildPortfolioList(),
            ),
            _buildAddAssetForm(),
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
                        primary: Colors.green,
                      ),
                      child: Text('Buy'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Button for selling the asset.
                        _showSellDialog(asset);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                      child: Text('Sell'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    } else {
      return Center(
        child: Text('No data available.'),
      );
    }
  }

  Widget _buildAddAssetForm() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Add Asset',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.04,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextFormField(
            controller: _assetNameController,
            style: textStyle(
              MediaQuery.of(context).size.width * 0.035,
              Colors.white,
              FontWeight.w600,
            ),
            decoration: InputDecoration(
              labelText: 'Asset Name',
              labelStyle:
                  TextStyle(color: Colors.white), // Set label text color
            ),
          ),
          TextFormField(
            controller: _tickerSymbolController,
            style: textStyle(
              MediaQuery.of(context).size.width * 0.035,
              Colors.white,
              FontWeight.w600,
            ),
            decoration: InputDecoration(
              labelText: 'Ticker Symbol',
              labelStyle: TextStyle(color: Colors.white),
            ),
          ),
          TextFormField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            style: textStyle(
              MediaQuery.of(context).size.width * 0.035,
              Colors.white,
              FontWeight.w600,
            ),
            decoration: InputDecoration(
              labelText: 'Quantity',
              labelStyle: TextStyle(color: Colors.white),
            ),
          ),
          TextFormField(
            controller: _totalInvestedController,
            keyboardType: TextInputType.number,
            style: textStyle(
              MediaQuery.of(context).size.width * 0.035,
              Colors.white,
              FontWeight.w600,
            ),
            decoration: InputDecoration(
              labelText: 'Total Invested',
              labelStyle: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: _addAsset,
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _addAsset() {
    final String assetName = _assetNameController.text;
    final String tickerSymbol = _tickerSymbolController.text;
    final double quantity = double.tryParse(_quantityController.text) ?? 0;
    final double totalInvested =
        double.tryParse(_totalInvestedController.text) ?? 0.0;

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

      // Clear the input fields and trigger a rebuild of the widget.
      _assetNameController.clear();
      _tickerSymbolController.clear();
      _quantityController.clear();
      _totalInvestedController.clear();

      setState(() {});
    } else {
      // Show an error message to the user if any field is empty or invalid.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
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
                decoration: InputDecoration(labelText: 'Quantity'),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  totalInvested = double.tryParse(value) ?? 0;
                },
                decoration: InputDecoration(labelText: 'Total Invested'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _buyAsset(asset, quantity, totalInvested);
                Navigator.of(context).pop();
              },
              child: Text('Buy'),
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
                decoration: InputDecoration(labelText: 'Quantity'),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  totalInvested = double.tryParse(value) ?? 0;
                },
                decoration: InputDecoration(labelText: 'Total Invested'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _sellAsset(asset, quantity, totalInvested);
                Navigator.of(context).pop();
              },
              child: Text('Sell'),
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
        quantity: asset.quantity + quantity,
        totalInvested: asset.totalInvested + totalInvested,
      );

      _portfolioController.editAsset(updatedAsset, buy: true);

      // Trigger a rebuild of the widget.
      setState(() {});
    } else {
      // Show an error message to the user if the quantity or total investment is invalid.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Please enter a valid quantity and total invested amount.'),
        ),
      );
    }
  }

  void _sellAsset(Asset asset, double quantity, double totalInvested) {
    if (quantity > 0 && totalInvested > 0) {
      final Asset updatedAsset = Asset(
        assetName: asset.assetName,
        tickerSymbol: asset.tickerSymbol,
        quantity: asset.quantity - quantity,
        totalInvested: asset.totalInvested - totalInvested,
      );

      _portfolioController.editAsset(updatedAsset, buy: false);

      // Trigger a rebuild of the widget.
      setState(() {});
    } else {
      // Show an error message to the user if the quantity or total investment is invalid.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
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
}
