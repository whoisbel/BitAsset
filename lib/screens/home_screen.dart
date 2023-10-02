import 'package:bitset/controllers/crypto_controller.dart';
import 'package:bitset/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:intl/intl.dart';
import 'package:bitset/screens/portfolio.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var selectedCryptoData;

  final GlobalKey<NavigatorState> myNavigatorKey = GlobalKey<NavigatorState>();
  final CryptoController controller = Get.put(CryptoController());

  int defaultValue = 10;
  String? selectedDropdownValue = '10';
  final value = new NumberFormat("#,##0.00", "en_US");

  void onDropdownValueChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        selectedDropdownValue = newValue;
        defaultValue = int.parse(newValue);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/Portfolio': (context) => PortfolioViewPage(),
        },
        home: Scaffold(
          backgroundColor: Color.fromARGB(255, 44, 45, 44),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Cryptocurrencies",
                      style: textStyle(MediaQuery.of(context).size.width * 0.08,
                          Colors.white, FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DropdownButton<String>(
                        value: selectedDropdownValue,
                        onChanged: onDropdownValueChanged,
                        dropdownColor: Color.fromARGB(255, 44, 45, 44),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        items: [
                          DropdownMenuItem<String>(
                            value: '10',
                            child: Text('Top 10',
                                style: textStyle(
                                    MediaQuery.of(context).size.width * 0.05,
                                    Colors.white,
                                    FontWeight.bold)),
                          ),
                          DropdownMenuItem<String>(
                            value: '20',
                            child: Text('Top 20',
                                style: textStyle(
                                    MediaQuery.of(context).size.width * 0.05,
                                    Colors.white,
                                    FontWeight.bold)),
                          ),
                          DropdownMenuItem<String>(
                            value: '30',
                            child: Text('Top 30',
                                style: textStyle(
                                    MediaQuery.of(context).size.width * 0.05,
                                    Colors.white,
                                    FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Obx(
                    () => controller.isLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: defaultValue,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedCryptoData =
                                          controller.cryptoList[index];
                                    });
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor:
                                              Color.fromARGB(255, 44, 45, 44),
                                          title: Text('Crypto Details',
                                              style: textStyle(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05,
                                                  Colors.white,
                                                  FontWeight.w500)),
                                          content: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Sparkline(
                                                gridLinelabelPrefix: '\$',
                                                gridLineLabelPrecision: 7,
                                                enableGridLines: true,
                                                data: controller
                                                    .cryptoList[index]
                                                    .sparklineIn7D
                                                    .price,
                                                lineColor: _getColor(controller
                                                    .cryptoList[index]
                                                    .priceChangePercentage24H),
                                                lineWidth: 2,
                                              ),
                                              Text(
                                                  "Current rank: ${controller.cryptoList[index].marketCapRank}",
                                                  style: textStyle(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.05,
                                                      Colors.white,
                                                      FontWeight.w500)),
                                              Text(
                                                  'Name: ${controller.cryptoList[index].name}',
                                                  style: textStyle(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.05,
                                                      Colors.white,
                                                      FontWeight.w500)),
                                              Text(
                                                  'Symbol: ${controller.cryptoList[index].symbol.toUpperCase()}',
                                                  style: textStyle(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.05,
                                                      Colors.white,
                                                      FontWeight.w500)),
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          'Price Change (24H): ',
                                                      style: textStyle(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                        Colors.white,
                                                        FontWeight.w500,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          '${controller.cryptoList[index].priceChangePercentage24H.toStringAsFixed(2)}%',
                                                      style: textStyle(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                        _getColor(controller
                                                            .cryptoList[index]
                                                            .priceChangePercentage24H),
                                                        FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                  'Current Price: \$${controller.cryptoList[index].currentPrice.toStringAsFixed(2)}',
                                                  style: textStyle(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.05,
                                                      Colors.white,
                                                      FontWeight.w500)),
                                              Text(
                                                  'Current Market Cap: \$${value.format(controller.cryptoList[index].marketCap)}',
                                                  style: textStyle(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.05,
                                                      Colors.white,
                                                      FontWeight.w500)),
                                            ],
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Close'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        PortfolioViewPage(
                                                      cryptoData:
                                                          selectedCryptoData,
                                                    ),
                                                  ),
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'Added cryptocurrency in the portfolio'),
                                                  ),
                                                );
                                              },
                                              child: const Text(
                                                  'Add to Portfolio'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 60,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "${index + 1}.)",
                                              style: textStyle(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.04,
                                                  Colors.white,
                                                  FontWeight.w600),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.168,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.168,
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  child: Image.network(
                                                      controller
                                                          .cryptoList[index]
                                                          .image)),
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
                                                  style: textStyle(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.035,
                                                      Colors.white,
                                                      FontWeight.w600),
                                                ),
                                                Text(
                                                  "${controller.cryptoList[index].priceChangePercentage24H.toStringAsFixed(2)}%",
                                                  style: textStyle(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.035,
                                                      _getColor(controller
                                                          .cryptoList[index]
                                                          .priceChangePercentage24H),
                                                      FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "\$${controller.cryptoList[index].currentPrice.toStringAsFixed(2)}",
                                              style: textStyle(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.035,
                                                  Colors.white,
                                                  FontWeight.w600),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.08,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05,
                                              child: Sparkline(
                                                data: controller
                                                    .cryptoList[index]
                                                    .sparklineIn7D
                                                    .price,
                                                lineColor: _getColor(controller
                                                    .cryptoList[index]
                                                    .priceChangePercentage24H),
                                                lineWidth: 2,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
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
        ));
  }
}

Color _getColor(double percentage) {
  if (percentage > 0) {
    return Colors.green;
  } else if (percentage < 0) {
    return Colors.red;
  } else {
    return Colors.grey;
  }
}
