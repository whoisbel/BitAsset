// To parse this JSON data, do
//
//     final historicalModel = historicalModelFromJson(jsonString);

import 'dart:convert';

HistoricalModel historicalModelFromJson(String str) =>
    HistoricalModel.fromJson(json.decode(str));

String historicalModelToJson(HistoricalModel data) =>
    json.encode(data.toJson());

class HistoricalModel {
  String id;
  String symbol;
  String name;
  Localization localization;
  Image image;
  MarketData marketData;
  CommunityData communityData;
  DeveloperData developerData;
  PublicInterestStats publicInterestStats;

  HistoricalModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.localization,
    required this.image,
    required this.marketData,
    required this.communityData,
    required this.developerData,
    required this.publicInterestStats,
  });

  factory HistoricalModel.fromJson(Map<String, dynamic> json) =>
      HistoricalModel(
        id: json["id"],
        symbol: json["symbol"],
        name: json["name"],
        localization: Localization.fromJson(json["localization"]),
        image: Image.fromJson(json["image"]),
        marketData: MarketData.fromJson(json["market_data"]),
        communityData: CommunityData.fromJson(json["community_data"]),
        developerData: DeveloperData.fromJson(json["developer_data"]),
        publicInterestStats:
            PublicInterestStats.fromJson(json["public_interest_stats"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "symbol": symbol,
        "name": name,
        "localization": localization.toJson(),
        "image": image.toJson(),
        "market_data": marketData.toJson(),
        "community_data": communityData.toJson(),
        "developer_data": developerData.toJson(),
        "public_interest_stats": publicInterestStats.toJson(),
      };
}

class CommunityData {
  dynamic facebookLikes;
  dynamic twitterFollowers;
  int redditAveragePosts48H;
  int redditAverageComments48H;
  dynamic redditSubscribers;
  dynamic redditAccountsActive48H;

  CommunityData({
    required this.facebookLikes,
    required this.twitterFollowers,
    required this.redditAveragePosts48H,
    required this.redditAverageComments48H,
    required this.redditSubscribers,
    required this.redditAccountsActive48H,
  });

  factory CommunityData.fromJson(Map<String, dynamic> json) => CommunityData(
        facebookLikes: json["facebook_likes"],
        twitterFollowers: json["twitter_followers"],
        redditAveragePosts48H: (json["reddit_average_posts_48h"] ?? 0).toInt(),
        redditAverageComments48H:
            (json["reddit_average_comments_48h"] ?? 0).toInt(),
        redditSubscribers: json["reddit_subscribers"],
        redditAccountsActive48H: json["reddit_accounts_active_48h"],
      );

  Map<String, dynamic> toJson() => {
        "facebook_likes": facebookLikes,
        "twitter_followers": twitterFollowers,
        "reddit_average_posts_48h": redditAveragePosts48H,
        "reddit_average_comments_48h": redditAverageComments48H,
        "reddit_subscribers": redditSubscribers,
        "reddit_accounts_active_48h": redditAccountsActive48H,
      };
}

class DeveloperData {
  dynamic forks;
  dynamic stars;
  dynamic subscribers;
  dynamic totalIssues;
  dynamic closedIssues;
  dynamic pullRequestsMerged;
  dynamic pullRequestContributors;
  CodeAdditionsDeletions4Weeks codeAdditionsDeletions4Weeks;
  dynamic commitCount4Weeks;

  DeveloperData({
    required this.forks,
    required this.stars,
    required this.subscribers,
    required this.totalIssues,
    required this.closedIssues,
    required this.pullRequestsMerged,
    required this.pullRequestContributors,
    required this.codeAdditionsDeletions4Weeks,
    required this.commitCount4Weeks,
  });

  factory DeveloperData.fromJson(Map<String, dynamic> json) => DeveloperData(
        forks: json["forks"],
        stars: json["stars"],
        subscribers: json["subscribers"],
        totalIssues: json["total_issues"],
        closedIssues: json["closed_issues"],
        pullRequestsMerged: json["pull_requests_merged"],
        pullRequestContributors: json["pull_request_contributors"],
        codeAdditionsDeletions4Weeks: CodeAdditionsDeletions4Weeks.fromJson(
            json["code_additions_deletions_4_weeks"]),
        commitCount4Weeks: json["commit_count_4_weeks"],
      );

  Map<String, dynamic> toJson() => {
        "forks": forks,
        "stars": stars,
        "subscribers": subscribers,
        "total_issues": totalIssues,
        "closed_issues": closedIssues,
        "pull_requests_merged": pullRequestsMerged,
        "pull_request_contributors": pullRequestContributors,
        "code_additions_deletions_4_weeks":
            codeAdditionsDeletions4Weeks.toJson(),
        "commit_count_4_weeks": commitCount4Weeks,
      };
}

class CodeAdditionsDeletions4Weeks {
  dynamic additions;
  dynamic deletions;

  CodeAdditionsDeletions4Weeks({
    required this.additions,
    required this.deletions,
  });

  factory CodeAdditionsDeletions4Weeks.fromJson(Map<String, dynamic> json) =>
      CodeAdditionsDeletions4Weeks(
        additions: json["additions"],
        deletions: json["deletions"],
      );

  Map<String, dynamic> toJson() => {
        "additions": additions,
        "deletions": deletions,
      };
}

class Image {
  String thumb;
  String small;

  Image({
    required this.thumb,
    required this.small,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        thumb: json["thumb"],
        small: json["small"],
      );

  Map<String, dynamic> toJson() => {
        "thumb": thumb,
        "small": small,
      };
}

class Localization {
  String en;
  String de;
  String es;
  String fr;
  String it;
  String pl;
  String ro;
  String hu;
  String nl;
  String pt;
  String sv;
  String vi;
  String tr;
  String ru;
  String ja;
  String zh;
  String zhTw;
  String ko;
  String ar;
  String th;
  String id;
  String cs;
  String da;
  String el;
  String hi;
  String no;
  String sk;
  String uk;
  String he;
  String fi;
  String bg;
  String hr;
  String lt;
  String sl;

  Localization({
    required this.en,
    required this.de,
    required this.es,
    required this.fr,
    required this.it,
    required this.pl,
    required this.ro,
    required this.hu,
    required this.nl,
    required this.pt,
    required this.sv,
    required this.vi,
    required this.tr,
    required this.ru,
    required this.ja,
    required this.zh,
    required this.zhTw,
    required this.ko,
    required this.ar,
    required this.th,
    required this.id,
    required this.cs,
    required this.da,
    required this.el,
    required this.hi,
    required this.no,
    required this.sk,
    required this.uk,
    required this.he,
    required this.fi,
    required this.bg,
    required this.hr,
    required this.lt,
    required this.sl,
  });

  factory Localization.fromJson(Map<String, dynamic> json) => Localization(
        en: json["en"],
        de: json["de"],
        es: json["es"],
        fr: json["fr"],
        it: json["it"],
        pl: json["pl"],
        ro: json["ro"],
        hu: json["hu"],
        nl: json["nl"],
        pt: json["pt"],
        sv: json["sv"],
        vi: json["vi"],
        tr: json["tr"],
        ru: json["ru"],
        ja: json["ja"],
        zh: json["zh"],
        zhTw: json["zh-tw"],
        ko: json["ko"],
        ar: json["ar"],
        th: json["th"],
        id: json["id"],
        cs: json["cs"],
        da: json["da"],
        el: json["el"],
        hi: json["hi"],
        no: json["no"],
        sk: json["sk"],
        uk: json["uk"],
        he: json["he"],
        fi: json["fi"],
        bg: json["bg"],
        hr: json["hr"],
        lt: json["lt"],
        sl: json["sl"],
      );

  Map<String, dynamic> toJson() => {
        "en": en,
        "de": de,
        "es": es,
        "fr": fr,
        "it": it,
        "pl": pl,
        "ro": ro,
        "hu": hu,
        "nl": nl,
        "pt": pt,
        "sv": sv,
        "vi": vi,
        "tr": tr,
        "ru": ru,
        "ja": ja,
        "zh": zh,
        "zh-tw": zhTw,
        "ko": ko,
        "ar": ar,
        "th": th,
        "id": id,
        "cs": cs,
        "da": da,
        "el": el,
        "hi": hi,
        "no": no,
        "sk": sk,
        "uk": uk,
        "he": he,
        "fi": fi,
        "bg": bg,
        "hr": hr,
        "lt": lt,
        "sl": sl,
      };
}

class MarketData {
  Map<String, double> currentPrice;
  Map<String, double> marketCap;
  Map<String, double> totalVolume;

  MarketData({
    required this.currentPrice,
    required this.marketCap,
    required this.totalVolume,
  });

  factory MarketData.fromJson(Map<String, dynamic> json) => MarketData(
        currentPrice: Map.from(json["current_price"])
            .map((k, v) => MapEntry<String, double>(k, v?.toDouble())),
        marketCap: Map.from(json["market_cap"])
            .map((k, v) => MapEntry<String, double>(k, v?.toDouble())),
        totalVolume: Map.from(json["total_volume"])
            .map((k, v) => MapEntry<String, double>(k, v?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "current_price": Map.from(currentPrice)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "market_cap":
            Map.from(marketCap).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "total_volume": Map.from(totalVolume)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}

class PublicInterestStats {
  dynamic alexaRank;
  dynamic bingMatches;

  PublicInterestStats({
    required this.alexaRank,
    required this.bingMatches,
  });

  factory PublicInterestStats.fromJson(Map<String, dynamic> json) =>
      PublicInterestStats(
        alexaRank: json["alexa_rank"],
        bingMatches: json["bing_matches"],
      );

  Map<String, dynamic> toJson() => {
        "alexa_rank": alexaRank,
        "bing_matches": bingMatches,
      };
}
