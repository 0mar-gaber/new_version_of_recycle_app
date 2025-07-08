import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:new_version_of_recycle_app/services/getApiService.dart';
import 'package:http/http.dart' as http;
import 'Constants/CustomStyles.dart';
import 'Constants/globals.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController _dateController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController dayController = TextEditingController();
  late int _quantity = 2;

  List<String> wasteNames = [];
  String? _wasteName;

  int? selectedCardIndex;
  List<num> kiloPrice = [];
  double minimumNumberOfKilos = 2;
  bool isLoading = true;

  final List<String> cardTitles = [
    "الفجر \n۱۲صباحاً - ٦ صباحاً",
    "صباحاً\n ٦ صباحاً - ۱۲ ظهراً",
    "بعد الظهر\n ۱۲ ظهراً - ٦ مساءً"
  ];

  Future<void> _selectDate(BuildContext context) async {
    DateTime currentDate = DateTime.now(); // الحصول على تاريخ اليوم
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate, // تعيين اليوم الحالي كتاريخ افتراضي
      firstDate: currentDate, // منع اختيار تواريخ قبل اليوم
      lastDate: DateTime(currentDate.year + 1), // تحديد آخر تاريخ يمكن اختياره
    );

    if (selectedDate != null && selectedDate != currentDate) {
      // تنسيق التاريخ المختار
      String formattedDate =
          DateFormat('EEEE dd - MM - yyyy').format(selectedDate);
      setState(() {
        _dateController.text = formattedDate; // عرض التاريخ في TextFormField
      });
    }
  }

  void sendRequest() async {
    setState(() {
      isLoading = true;
    });

    try {
      final selectedIndex = wasteNames.indexOf(_wasteName!);
      final pricePerKilo = kiloPrice[selectedIndex];
      final total = pricePerKilo * _quantity;

      final response = await ApiService().addWasteRequest(
        userPhone: phoneNumberController.text.isNotEmpty
            ? phoneNumberController.text
            : Globals().phone,
        quantity: _quantity.toString(),
        location: addressController.text,
        wasteName: _wasteName!,
        totalPrice: total.toString(),
        requestDate: DateTime.now().toIso8601String(),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        // ✅ الطلب تم بنجاح - امسح القيم واظهر رسالة نجاح
        setState(() {
          phoneNumberController.clear();
          addressController.clear();
          _dateController.clear();
          _wasteName = null;
          selectedCardIndex = null;
          _quantity = 2;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("تم إرسال الطلب بنجاح ✅"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // ❌ الطلب فشل - اظهر رسالة من الـ API
        final message =   'حدث خطأ غير متوقع';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("فشل في إرسال الطلب ❌: $message"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء الإرسال: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void onCardTapped(int index) {
    setState(() {
      selectedCardIndex = index; // Toggle selection
    });
  }

  void _onPlus() {
    setState(() {
      _quantity++;
    });
  }

  void _onMinus() {
    setState(() {
      if (_quantity <= 2) {
        _quantity = 3;
      }
      _quantity--;
      // Globals().totalCoins-=Count;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchWasteNames();
  }

  Future<void> fetchWasteNames() async {
    try {
      final response = await http
          .get(Uri.parse("${Globals.baseUrl}/api/WasteType"));

      if (response.statusCode == 200) {
        // Decode the JSON response
        List<dynamic> data = jsonDecode(response.body);

        // Extract the wasteName from each map and update the state
        setState(() {
          wasteNames = data.map((item) => item['wasteName'] as String).toList();
          kiloPrice = data.map((item) => item['price'] as num).toList();
          isLoading = false;
        });
      } else {
        // Handle error
        throw Exception('Failed to load waste names');
      }
    } catch (error) {
      // Handle network or parsing errors
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: [
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
                  Text(
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
          //Second row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 13,
                      ),
                      Text(
                        "حدد الكمية",
                        style: TextStyle(
                            fontSize: 23,
                            fontFamily: "Almarai",
                            color: Colors.black54
                            // color: Color(0xFF1D8560)

                            ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: _onMinus,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Color(0xFFf25d01), // Border color
                                  width: 2.0, // Border width
                                ),
                              ),
                              height: 40,
                              width: 40,
                              child: Icon(
                                Icons.exposure_minus_1,
                                color: Color(0xFFf25d01),
                              ),
                            ),
                          ),
                          Container(
                              width: 80,
                              child: Image.asset(
                                "assets/images/bottle.png",
                                fit: BoxFit.fitWidth,
                              )),
                          GestureDetector(
                            onTap: _onPlus,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Color(0xFFf25d01), // Border color
                                  width: 2.0, // Border width
                                ),
                              ),
                              height: 40,
                              width: 40,
                              child: Icon(
                                Icons.add,
                                color: Color(0xFFf25d01),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "كيلـو",
                            style: TextStyle(
                                fontSize: 22,
                                fontFamily: "Almarai",
                                color: Colors.black87
                                // color: Color(0xFF1D8560)

                                ),
                          ),
                          Text(
                            " " + "$_quantity",
                            style: TextStyle(
                                fontSize: 22,
                                fontFamily: "Almarai",
                                color: Colors.black87
                                // color: Color(0xFF1D8560)

                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "حدد نوع المنتج",
                        style: TextStyle(
                            fontSize: 22,
                            fontFamily: "Almarai",
                            color: Colors.black54
                            // color: Color(0xFF1D8560)

                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: 165,
                        height: 50,
                        child: DropdownButtonFormField<String>(
                          style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.normal,
                              fontFamily: "Almarai",
                              color: Color(0xFF1D8560)),
                          value: _wasteName,
                          onChanged: (String? waste) {
                            setState(() {
                              _wasteName = waste;

                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                          items: wasteNames
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              "جنيه ",
                              style: CustomStyles.UnSelectedLabel,
                            ),
                            Text(
                              _wasteName != null
                                  ? (kiloPrice[wasteNames.indexOf(_wasteName!)] ).toString()
                                  : "0",
                              style: CustomStyles.UnSelectedLabel,
                            ),
                          ],
                        ),
                        const Text(
                          "  سعر الكيلو",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.normal,
                            fontFamily: "Almarai",
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              "( ",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Almarai",
                              ),
                            ),
                            Text(
                              "كيلو ",
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFFf25d01),
                                fontFamily: "Almarai",
                              ),
                            ),
                            Text(
                              "$minimumNumberOfKilos",
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFFf25d01),
                                fontFamily: "Almarai",
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "  أقل كمية )",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Almarai",
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "رقم التليفون",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Almarai",
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // لون النص الأخضر الداكن
                    ),
                  ),
                ),
                TextFormField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.phone,
                  maxLength: 11,
                  textAlign: TextAlign.right, // Align text to the right
                  decoration: CustomStyles.customInputDecoration(
                    hintText: Globals().phone,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(
                    "المدينة",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Almarai",
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // لون النص الأخضر الداكن
                    ),
                  ),
                ),
                TextFormField(
                  controller: addressController,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.right, // Align text to the right
                  decoration: CustomStyles.customInputDecoration(
                    hintText: "minya",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0, bottom: 5),
                  child: Text(
                    "موعد الاستلام",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Almarai",
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // لون النص الأخضر الداكن
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Container(
                  padding: EdgeInsets.only(left: 7.0),
                  height: 70,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: cardTitles.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => onCardTapped(index),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: selectedCardIndex == index
                                    ? Color(0xFFf25d01)
                                    : Color(0xffbdbdbc),
                              ),
                              width: 120,
                              child: Center(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  cardTitles[index],
                                  style: TextStyle(
                                    fontFamily: "Almarai",
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: selectedCardIndex == index
                                        ? Colors.white
                                        : Color(0xFF1D8560),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ])),
          Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "اليوم",
                  style: TextStyle(
                      fontSize: 22,
                      fontFamily: "Almarai",
                      color: Colors.black87),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    controller: _dateController,
                    keyboardType: TextInputType.streetAddress,
                    textAlign: TextAlign.right, // Align text to the right
                    decoration:
                        InputDecoration(suffixIcon: IconButton(
                            onPressed: () => _selectDate(context),
                    icon: Icon(Icons.calendar_today))),
                    readOnly: true,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: sendRequest,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      height: 60,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color(0xFFf25d01),
                      ),
                      child: Center(
                          child: Text(
                        "إرسال الطلب",
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Almarai",
                            color: Colors.white),
                      )),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "إجمالي السعر",
                      style: TextStyle(
                          fontSize: 24,
                          fontFamily: "Almarai",
                          color: Colors.black87
                          // color: Color(0xFF1D8560)

                          ),
                    ),
                    Row(
                      children: [
                        Text(
                          " جنيه",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              fontFamily: "Almarai",
                              color: Color(0xFFf25d01)
                              // color: Color(0xFF1D8560)

                              ),
                        ),
                        Text(
                          _wasteName != null
                              ? (kiloPrice[wasteNames.indexOf(_wasteName!)] * _quantity).toString()
                              : "0",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              fontFamily: "Almarai",
                              color: Color(0xFFf25d01)
                              // color: Color(0xFF1D8560)

                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
