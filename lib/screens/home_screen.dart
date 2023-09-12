import 'package:bitset/controllers/crypto_controller.dart';
import 'package:bitset/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chart_sparkline/chart_sparkline.dart';

class HomeScreen extends StatelessWidget {
  final CryptoController controller = Get.put(CryptoController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Cryptocurrencies",
                  style: textStyle(25, Colors.white, FontWeight.bold)),
              Obx(
                () => controller.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 15,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Image.network(controller
                                                .cryptoList[index].image)),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "${controller.cryptoList[index].name} (${controller.cryptoList[index].symbol.toUpperCase()})",
                                            style: textStyle(16, Colors.white,
                                                FontWeight.w600),
                                          ),
                                          Text(
                                            "${controller.cryptoList[index].priceChangePercentage24H}%",
                                            style: textStyle(
                                                18,
                                                _getColor(controller
                                                    .cryptoList[index]
                                                    .priceChangePercentage24H),
                                                FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "\$${controller.cryptoList[index].currentPrice}",
                                        style: textStyle(
                                            16, Colors.white, FontWeight.w600),
                                      ),
                                      Container(
                                        width: 90,
                                        height: 50,
                                        child: Sparkline(
                                          data: controller.cryptoList[index]
                                              .sparklineIn7D.price,
                                          lineColor: _getColor(controller
                                              .cryptoList[index]
                                              .priceChangePercentage24H),
                                        ),
                                      )

                                      //Add Sparkline here
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color _getColor(double percentage) {
  if (percentage > 0) {
    return Colors.green; // Positive percentage, display in green
  } else if (percentage < 0) {
    return Colors.red; // Negative percentage, display in red
  } else {
    return Colors
        .grey; // Zero percentage, display in grey or any other color you prefer
  }
}
