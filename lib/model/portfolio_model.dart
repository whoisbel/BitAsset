import 'dart:convert';

PortfolioModel portfolioModelFromJson(String str) =>
    PortfolioModel.fromJson(json.decode(str));

String portfolioModelToJson(PortfolioModel data) => json.encode(data.toJson());

class PortfolioModel {
  List<Asset> assets;

  PortfolioModel({
    required this.assets,
  });

  factory PortfolioModel.fromJson(Map<String, dynamic> json) => PortfolioModel(
        assets: List<Asset>.from(json["assets"].map((x) => Asset.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "assets": List<dynamic>.from(assets.map((x) => x.toJson())),
      };
}

class Asset {
  String assetName;
  String tickerSymbol;
  double quantity;
  double totalInvested;

  Asset({
    required this.assetName,
    required this.tickerSymbol,
    required this.quantity,
    required this.totalInvested,
  });

  factory Asset.fromJson(Map<String, dynamic> json) => Asset(
        assetName: json["asset_name"],
        tickerSymbol: json["ticker_symbol"],
        quantity: json["quantity"],
        totalInvested: json["total_invested"],
      );

  Map<String, dynamic> toJson() => {
        "asset_name": assetName,
        "ticker_symbol": tickerSymbol,
        "quantity": quantity,
        "total_invested": totalInvested,
      };
}
