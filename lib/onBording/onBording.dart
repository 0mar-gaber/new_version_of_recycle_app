import 'package:flutter/material.dart';
import 'package:new_version_of_recycle_app/Main_page.dart';
import '../Constants/CustomStyles.dart';
import '../First_Screen.dart';
import 'onBordingContent.dart';

class Onbording extends StatefulWidget {
  const Onbording({super.key});

  @override
  State<Onbording> createState() => _OnbordingState();
}

class _OnbordingState extends State<Onbording> {
  int currentIndex = 2;
  String pageImage = "assets/images/Box.png";
  late PageController _controller;
  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1D8560),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image.asset(pageImage),
          SizedBox(
            height: 60,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            height: 350,
            width: double.infinity,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 30),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      contents.length,
                      (index) => buildDot(index, context),
                    ),
                  ),
                ),
              ),
              Container(
                height: 215,
                child: PageView.builder(
                  controller: _controller,
                  itemCount: contents.length,
                  onPageChanged: (int index) {
                    setState(() {
                      currentIndex = index;
                      pageImage = contents[index].image;
                    });
                  },
                  itemBuilder: (_, i) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 40, right: 40, top: 40),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                contents[i].greenPartOfTitle,
                                style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1D8560),
                                    fontFamily: "Almarai"),
                              ),
                              Text(
                                contents[i].title,
                                style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Almarai"),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Text(
                            contents[i].discription,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                                fontFamily: "Almarai"),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              if (currentIndex == contents.length - 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        _controller.previousPage(
                          duration: Duration(milliseconds: 100),
                          curve: Curves.bounceInOut,
                        );
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            color: Color(0xFFf25d01),
                            borderRadius: BorderRadius.circular(30)),
                        child: Center(
                            child: Icon(
                          Icons.arrow_back,
                          size: 30,
                          color: Colors.white,
                        )),
                      ),
                    ),
                  ],
                ),
              if (currentIndex == contents.length - 2)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        _controller.previousPage(
                          duration: Duration(milliseconds: 100),
                          curve: Curves.bounceIn,
                        );
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            color: Color(0xFFf25d01),
                            borderRadius: BorderRadius.circular(30)),
                        child: Center(
                            child: Icon(
                          Icons.arrow_back,
                          size: 30,
                          color: Colors.white,
                        )),
                      ),
                    ),
                    SizedBox(
                      width: 210,
                    ),
                    GestureDetector(
                      onTap: () {
                        _controller.nextPage(
                          duration: Duration(milliseconds: 100),
                          curve: Curves.bounceIn,
                        );
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFFf25d01)),
                            borderRadius: BorderRadius.circular(30)),
                        child: Center(
                            child: Icon(
                          Icons.arrow_forward,
                          size: 30,
                          color: Color(0xFFf25d01),
                        )),
                      ),
                    ),
                  ],
                ),
              if (currentIndex == 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 40),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FirstScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: 60,
                        width: 170,
                        decoration: BoxDecoration(
                          color: Color(0xFFf25d01),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_left_sharp,
                                color: Colors.white,
                                size: 35,
                              ),
                              Text(
                                "إبدأ إعادة التدوير",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontFamily: "Almarai",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 100),
                    GestureDetector(
                      onTap: () {
                        _controller.animateToPage(
                          currentIndex + 1, // ينتقل إلى الصفحة التالية
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut, // سلاسة في الحركة
                        );
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFf25d01)),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.arrow_forward,
                            size: 30,
                            color: Color(0xFFf25d01),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
            ]),
          ),
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 5,
      width: 80,
      margin: EdgeInsets.only(right: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: currentIndex == index
            ? Theme.of(context).primaryColor
            : Colors.grey[300],
      ),
    );
  }
}
