import 'package:bitset/model/portfolio_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PortfolioController {
  final SharedPreferences prefs;

  PortfolioController(this.prefs);

  PortfolioModel get portfolioModel {
    final String? portfolioJson = prefs.getString('portfolioModel');
    if (portfolioJson == null) {
      return PortfolioModel(assets: []);
    } else {
      return portfolioModelFromJson(portfolioJson);
    }
  }

  void addAsset(Asset asset) {
    final PortfolioModel portfolioModel = this.portfolioModel;

    final int existingAssetIndex = portfolioModel.assets
        .indexWhere((a) => a.tickerSymbol == asset.tickerSymbol);
    if (existingAssetIndex != -1) {
      portfolioModel.assets[existingAssetIndex].quantity += asset.quantity;
      portfolioModel.assets[existingAssetIndex].totalInvested +=
          asset.totalInvested;
    } else {
      portfolioModel.assets.add(asset);
    }
    prefs.setString('portfolioModel', portfolioModelToJson(portfolioModel));
  }

  void editAsset(Asset asset) {
    final PortfolioModel portfolioModel = this.portfolioModel;

    final int assetIndex = portfolioModel.assets
        .indexWhere((a) => a.tickerSymbol == asset.tickerSymbol);

    if (assetIndex != -1) {
      portfolioModel.assets[assetIndex].quantity = asset.quantity;
      portfolioModel.assets[assetIndex].totalInvested = asset.totalInvested;
    }

    prefs.setString('portfolioModel', portfolioModelToJson(portfolioModel));
  }

  void removeAsset(String tickerSymbol) {
    final PortfolioModel portfolioModel = this.portfolioModel;

    final int assetIndex =
        portfolioModel.assets.indexWhere((a) => a.tickerSymbol == tickerSymbol);

    if (assetIndex != -1) {
      portfolioModel.assets.removeAt(assetIndex);
    }

    prefs.setString('portfolioModel', portfolioModelToJson(portfolioModel));
  }
}
