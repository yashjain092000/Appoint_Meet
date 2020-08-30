import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

class CarouselPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 150.0,
        width: 300.0,
        child: Carousel(
          boxFit: BoxFit.cover,
          autoplay: true,
          animationCurve: Curves.decelerate, //Curves.fastOutSlowIn,
          animationDuration: Duration(milliseconds: 1000),
          dotSize: 4.0,
          dotIncreasedColor: Color(0xFFFF335C),
          dotBgColor: Colors.transparent,
          dotPosition: DotPosition.bottomCenter,
          dotVerticalPadding: 10.0,
          showIndicator: true,
          indicatorBgPadding: 0.0,
          images: [
            NetworkImage(
                'https://cdn-images-1.medium.com/max/2000/1*GqdzzfB_BHorv7V2NV7Jgg.jpeg'),
            NetworkImage("https://www.w3schools.com/images/picture.jpg"),
            NetworkImage(
                'https://cdn-images-1.medium.com/max/2000/1*wnIEgP1gNMrK5gZU7QS0-A.jpeg'),
            NetworkImage("https://www.w3schools.com/images/picture.jpg"),
            NetworkImage(
                'https://cdn-images-1.medium.com/max/2000/1*wnIEgP1gNMrK5gZU7QS0-A.jpeg'),
            NetworkImage("https://www.w3schools.com/images/picture.jpg"),
            // ExactAssetImage("assets/images/logopng.png"),
          ],
        ),
      ),
    );
  }
}
