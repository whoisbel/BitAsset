import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:bitset/model/historical_model.dart';

class HistoricalController extends GetxController {
  Rx<HistoricalModel?> historicalModel = Rx<HistoricalModel?>(null);
  RxBool isLoading = true.obs;

  @override
  onInit() {
    super.onInit();
    fetchHistoricalData("ethereum", "1-1-2016");
  }

  fetchHistoricalData(String coinSymbol, String date) async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(
          'https://api.coingecko.com/api/v3/coins/$coinSymbol/history?date=$date'));
      if (response.statusCode == 200) {
        HistoricalModel data = historicalModelFromJson(response.body);
        historicalModel.value = data;
      } else {
        print('Failed to load historical data');
      }
    } finally {
      isLoading(false);
    }
  }
}
