import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Constants/CustomStyles.dart';
import 'Constants/globals.dart';
import 'Sales_statistics.dart';

class CoinsPage extends StatefulWidget {
  const CoinsPage({super.key});

  @override
  State<CoinsPage> createState() => _CoinsPageState();
}

class _CoinsPageState extends State<CoinsPage> {
  List<dynamic> _data = [];
  bool isLoading = true;

  Future<void> fetchData() async {
    final url =
        Uri.parse('${Globals.baseUrl}/api/RecyclingRequest/lastActivity');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        List<dynamic> alldata = json.decode(response.body);
        _data = alldata.length > 4
            ? alldata.sublist(alldata.length - 4, alldata.length)
            : alldata;
        isLoading = false;
        print(_data);
      });
    } else {
      print('Failed to load users');
    }
  }

  int coins  = 0 ;

  calculateCoins() async {
    final url = Uri.parse('${Globals.baseUrl}/api/RecyclingRequest/statistics');
    final response = await http.get(url);
    if (response.statusCode == 200) {

      int total = (jsonDecode(response.body)["totalQuantity"] as num).toInt();

      coins = total * 3 ;
      print(coins);

    } else {
      print('Failed to load users');
    }

  }

  String formatDate(String apiDate) {
    DateTime parsedDate = DateTime.parse(apiDate);

    String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);

    return formattedDate;
  }

  @override
  void initState() {
    calculateCoins();
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return ListView(children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: double.infinity - 20,
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 163,
                    child: Image.asset(
                      "assets/images/Prize.png",
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "رصيدك الكوينز",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              fontFamily: "Almarai",
                              color: Colors.black),
                        ),
                        Row(
                          children: [
                            Text(
                              " كوينز ",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: "Almarai",
                                  color: Color(0xFFf25d01)),
                            ),
                            Text(
                              "${coins}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  fontFamily: "Almarai",
                                  color: Color(0xFFf25d01)),
                            ),
                          ],
                        ),
                        Container(
                          height: 45,
                          width: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Color(0xffd85504),
                          ),
                          child: Center(
                              child: Text(
                            "استرداد",
                            style: TextStyle(
                                fontSize: 25,
                                fontFamily: "Almarai",
                                color: Colors.white),
                          )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(
            "آخر الأنشطة",
            style: TextStyle(
                fontSize: 25, fontFamily: "Almarai", color: Colors.black),
          ),
          isLoading
              ? CircularProgressIndicator()
              : DataTable(
                  columns: [
                    DataColumn(label: Text('A')),
                    DataColumn(label: Text('B')),
                    DataColumn(label: Text('C')),
                  ],
                  rows: _data.map((item) {
                    return DataRow(cells: [
                      DataCell(Text(item['wasteName'].toString() ?? '')),
                      DataCell(Text(item['totalPrice'].toString() ?? '')),
                      DataCell(Text(formatDate(item['requestDate'] ?? ''))),
                    ]);
                  }).toList(),
                ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SalesStatistics(),
                        ),
                      );
                    },
                    child: Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                          color: Color(0xFFf25d01),
                          borderRadius: BorderRadius.circular(25)),
                      child: Center(
                          child: Text(
                        "إحصائيات عمليات البيع",
                        style: CustomStyles.ButtonsStyle,
                      )),
                    ),
                  ),
                ]),
          ),
        ],
      ),
    ]);
  }
}
