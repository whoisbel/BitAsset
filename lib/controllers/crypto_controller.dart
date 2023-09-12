import 'package:get/get.dart';
import 'package:bitset/model/crypto_model.dart';
import 'package:http/http.dart' as http;

class CryptoController extends GetxController {
  RxList<Crypto> cryptoList = <Crypto>[].obs;
  RxBool isLoading = true.obs;

  @override
  onInit() {
    super.onInit();
    fetchCrypto();
  }

  fetchCrypto() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(
          "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=true&locale=en"));
      List<Crypto> crypto = cryptoFromJson(response.body);
      cryptoList.value = crypto;
    } finally {
      isLoading(false);
    }
  }
}
