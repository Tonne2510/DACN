
import 'package:ecommerce_sem4/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;


class HomeSlide extends StatefulWidget {
  @override
  _CarouselWithThreeSlidesState createState() => _CarouselWithThreeSlidesState();
}

class _CarouselWithThreeSlidesState extends State<HomeSlide> {
  final CarouselSliderController _controller = CarouselSliderController(); // Create a CarouselController
  final List<String> imgList = [
    'assets/user/images/slide1.jpg',
    'assets/user/images/slide2.jpg',
    'assets/user/images/slide3.png',
    'assets/user/images/slide4.png',
    'assets/user/images/slide5.jpg',
  ];

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return
      Column(
        children: [
          CarouselSlider(
          carouselController: _controller, // Use the controller
          options: CarouselOptions(
            height: 200,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
          items: imgList.map((item) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 0.0),
            child:  Image.asset(
              item,
              fit: BoxFit.contain,
            ),
          )).toList(),
        ),
    Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: imgList.asMap().entries.map((entry) {
        return GestureDetector(
        onTap: () => _controller.animateToPage(entry.key), // Use the controller
        child: Container(
        width: 12.0,
        height: 12.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
              color: (  _current != entry.key) ? greyColor: greenBgColor),
            ),
          );
          }).toList(),
        ),
     ],
    );
  }
}


