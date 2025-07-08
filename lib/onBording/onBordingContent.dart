class onBordingContent {
  String title;
  String greenPartOfTitle;
  String discription;
  String image;

  onBordingContent(
      {required this.title,
      required this.discription,
        required this.image,
      required this.greenPartOfTitle});
}

List<onBordingContent> contents = [
  onBordingContent(
    title: ' احصل على ',
    greenPartOfTitle: 'كوينز',
    discription:
        "احصل على كوينز كل ما تعمل طلب إعادة تدوير منتج", image: 'assets/images/Coins.png',
  ),
  onBordingContent(
    title: ' أكتب',
    greenPartOfTitle: 'بياناتك',
    discription:
        "املأ بياناتك بالكامل عشان يتسجل طلبك", image: 'assets/images/Info.png',
  ),
  onBordingContent(
    title: ' إختر نوع',
    greenPartOfTitle: 'المنتج',
    discription:
        "اختار نوع المنتج اللي عايز اعادة تدويره", image: 'assets/images/Box.png',
  ),
];
