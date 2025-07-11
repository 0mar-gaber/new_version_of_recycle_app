import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;

import 'Constants/CustomStyles.dart';
import 'Constants/globals.dart';

class SalesStatistics extends StatefulWidget {
  const SalesStatistics({super.key});

  @override
  State<SalesStatistics> createState() => _SalesStatisticsState();


}

class _SalesStatisticsState extends State<SalesStatistics> {
  List<double> values = [20, 40, 30];
  int total = 0 ;

  getProductQuantity() async {
    final url = Uri.parse('${Globals.baseUrl}/api/RecyclingRequest/statistics');
    final response = await http.get(url);
    if (response.statusCode == 200) {

      total = (jsonDecode(response.body)["totalQuantity"] as num).toInt();

      setState(() {

      });
      print(total);

    } else {
      print('Failed to load users');
    }

  }

  @override
  void initState() {
    getProductQuantity();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff9ce1d4), // Start color
              Color(0xFFFFFFFF), // End color
            ],
            begin: Alignment.topCenter,
            end: Alignment.center,
          ),
        ),
        child: Center(
          child: ListView(children: [
            const Text(
              textAlign: TextAlign.center,
              "إحصائيات عمليات البيع",
              style: TextStyle(
                  fontSize: 24,
                  fontFamily: "Almarai",
                  color:Color(0xFFf25d01)
                // color: Color(0xFF1D8560)

              ),
            ),
            //First row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    height: 160,
                    child: Image.asset(
                      "assets/images/Home tree.png",
                      fit: BoxFit.fitHeight,
                    )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 110,
                        child: Image.asset("assets/images/Logo.png",
                            fit: BoxFit.fitHeight)),
                    const Text(
                      "بيئتك هي بيئتك",
                      style: TextStyle(
                          fontSize: 22,
                          fontFamily: "Almarai",
                          color: Colors.black87
                          // color: Color(0xFF1D8560)

                          ),
                    )
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  SizedBox(
                    height: 200,
                    width: 180,
                    child: PieChart(
                      PieChartData(
                        sections: showingSections(),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 0,
                        centerSpaceRadius: 0,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                            width: 200,
                            child: const Text(
                              "إجمالي المنتجات المعاد تدويرها حتى الان",
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 25, fontFamily: "Almarai", color:Color(0xFF1D8560)),
                            )),
                      ),
                      Row(
                        children: [
                          const Text(
                            " منتج ",
                            style: TextStyle(
                                fontSize: 30,
                                fontFamily: "Almarai",
                                color: Color(0xFFf25d01)),
                          ),
                          Text(
                            "$total",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                fontFamily: "Almarai",
                                color: Color(0xFFf25d01)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                textAlign: TextAlign.center,
                "هدفنا الوصول الى 100 الف منتج معاد تدويره",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    fontFamily: "Almarai",
                    color: Color(0xFF1D8560)),
              ),
            ),
            const SizedBox(height: 100,),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                textAlign: TextAlign.center,
                "ساعدنا في تحقيق هدفنا",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    fontFamily: "Almarai",
                    color: Color(0xFF1D8560)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100.0,vertical: 10),
              child: Container(
                height:50,
                decoration: BoxDecoration(
                    color: Color(0xFFf25d01),
                    borderRadius: BorderRadius.circular(25)),
                child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.reply_all_outlined,color: Colors.white,),
                        SizedBox(width: 15,),
                        Text(
                          "مشاركة التطبيق",
                          style: CustomStyles.ButtonsStyle,
                        ),
                      ],
                    )),
              ),
            ),
            const Text(
              textAlign: TextAlign.center,
              "شركاء نجاحنا",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  fontFamily: "Almarai",
                  color: Color(0xFF1D8560)),
            ),
          ]),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(values.length, (i) {
      final isTouched = i == 0; // Example: highlight the first section
      final color = Colors.primaries[i % Colors.primaries.length];
      return PieChartSectionData(
        color: const Color(0xFF73afaf),
        value: values[i],
        borderSide: const BorderSide(color: Colors.white),
        title: '${values[i].toInt()}%',
        radius: isTouched ? 100 : 90,
        titleStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }
}
