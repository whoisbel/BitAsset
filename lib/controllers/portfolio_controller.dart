import 'package:bitset/model/portfolio_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PortfolioController {
  final SharedPreferences prefs;

  PortfolioController(this.prefs);

  PortfolioModel get portfolioModel {
    // Get the portfolio model from shared preferences.
    final String? portfolioJson = prefs.getString('portfolioModel');
    if (portfolioJson == null) {
      return PortfolioModel(assets: []);
    } else {
      return portfolioModelFromJson(portfolioJson);
    }
  }

  void addAsset(Asset asset) {
    // Get the existing portfolio model.
    final PortfolioModel portfolioModel = this.portfolioModel;

    // Find the existing asset in the portfolio model.
    final int existingAssetIndex = portfolioModel.assets
        .indexWhere((a) => a.tickerSymbol == asset.tickerSymbol);

    // If the asset already exists, just add the quantity and total invested.
    if (existingAssetIndex != -1) {
      portfolioModel.assets[existingAssetIndex].quantity += asset.quantity;
      portfolioModel.assets[existingAssetIndex].totalInvested +=
          asset.totalInvested;
    } else {
      // Otherwise, add the new asset to the portfolio model.
      portfolioModel.assets.add(asset);
    }

    // Save the updated portfolio model to shared preferences.
    prefs.setString('portfolioModel', portfolioModelToJson(portfolioModel));
  }

  void editAsset(Asset asset) {
    // Get the existing portfolio model.
    final PortfolioModel portfolioModel = this.portfolioModel;

    // Find the existing asset in the portfolio model.
    final int assetIndex = portfolioModel.assets
        .indexWhere((a) => a.tickerSymbol == asset.tickerSymbol);

    // If the asset exists, update its quantity and total invested based on the buy/sell operation.
    if (assetIndex != -1) {
      portfolioModel.assets[assetIndex].quantity = asset.quantity;
      portfolioModel.assets[assetIndex].totalInvested = asset.totalInvested;
    }

    // Save the updated portfolio model to shared preferences.
    prefs.setString('portfolioModel', portfolioModelToJson(portfolioModel));
  }

  void removeAsset(String tickerSymbol) {
    // Get the existing portfolio model.
    final PortfolioModel portfolioModel = this.portfolioModel;

    // Find the existing asset in the portfolio model.
    final int assetIndex =
        portfolioModel.assets.indexWhere((a) => a.tickerSymbol == tickerSymbol);

    // If the asset exists, remove it from the portfolio model.
    if (assetIndex != -1) {
      portfolioModel.assets.removeAt(assetIndex);
    }

    // Save the updated portfolio model to shared preferences.
    prefs.setString('portfolioModel', portfolioModelToJson(portfolioModel));
  }
}
