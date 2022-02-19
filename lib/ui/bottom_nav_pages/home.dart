import 'dart:ui';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paikart/const/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../product_details_screen.dart';
import '../search_screen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> _carouselImages = [];
  List<String> _carousel = ['https://cdn.graygrids.com/wp-content/uploads/2017/05/Home-Owl-Carousel-2.2.1.png',
    'https://wowslider.com/sliders/demo-77/data1/images/road220058.jpg',
    'https://firebasestorage.googleapis.com/v0/b/paikart-e01ad.appspot.com/o/beautiful-bride-with-her-husband-park.jpg?alt=media&token=89b49ba9-ad8c-4d7c-b9f0-ed56a21b5468',
    'https://firebasestorage.googleapis.com/v0/b/paikart-e01ad.appspot.com/o/5f9f5e5943de7e69a1339242_5f44a7398c0cdf460857e744_img-image.jpeg?alt=media&token=3047f71f-4e56-4b75-a859-ca5556295bec',
    'https://firebasestorage.googleapis.com/v0/b/flutter-e-commerce-b8c7b.appspot.com/o/product-img%2Fwedding-archway-backyard-happy-wedding-couple-outdoors-before-wedding-ceremony.jpg?alt=media&token=29cc1b20-94ad-42c9-b5e4-b30876db3af2'];
  var _dotPosition = 0 ;
  List _products = [];
  var _firestoreInstance = FirebaseFirestore.instance;

  fetchCarouselImages() async {
    QuerySnapshot qn = await _firestoreInstance.collection("carousel-slider").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _carouselImages.add(
          qn.docs[i]["img"],
        );
        print('yesssssssssss');
      }
    });

    return qn.docs;
  }

  fetchProducts() async {
    QuerySnapshot qn = await _firestoreInstance.collection("products").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _products.add({
          "product-name": qn.docs[i]["product-name"],
          "product-description": qn.docs[i]["product-description"],
          "product-price": qn.docs[i]["product-price"],
          "product-img": qn.docs[i]["product-img"],
        });
      }
    });

    return qn.docs;
  }

  @override
  void initState() {
    fetchCarouselImages();
    fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(_carouselImages.length);
    print('yes');
    return Scaffold(
      body: SafeArea(
          child: Container(
            child: Column(
            children: [
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w),
              child: TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                      borderSide: BorderSide(color: Colors.blue)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                      borderSide: BorderSide(color: Colors.grey)),
                  hintText: "Search products here",
                  hintStyle: TextStyle(fontSize: 15.sp),
                ),
                onTap: () => Navigator.push(context,
                    CupertinoPageRoute(builder: (_) => SearchScreen())),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            AspectRatio(
              aspectRatio: 3.5,
              child: CarouselSlider(
                items: _carousel
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                  image: NetworkImage(item,),
                                  fit: BoxFit.fitWidth)),
                        ),
                      ),
                    )
                    .toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  enlargeCenterPage: true,
                  viewportFraction: 0.8,
                  enableInfiniteScroll: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  onPageChanged: (val, carouselPageChangedReason) {
                    setState(() {
                      _dotPosition = val;
                    });
                  },
                ),
              //   items: [
              //     Container(),
              //   ],
              // ),*/

            ),),
            SizedBox(
              height: 10.h,
            ),
            DotsIndicator(
              dotsCount:
                  _carousel.length == 0 ? 1 : _carousel.length,
              position: _dotPosition.toDouble(),
              decorator: DotsDecorator(
                activeColor: AppColors.deep_orange,
                color: AppColors.deep_orange.withOpacity(0.5),
                spacing: EdgeInsets.all(2),
                activeSize: Size(15, 15),
                size: Size(8, 8),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Expanded(
              child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,mainAxisSpacing: 15, childAspectRatio: 1),
                    itemBuilder: (_, index) {
                      return GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetails(_products[index]))),
                        child: Card(
                          elevation: 3,
                          child: Column(
                            children: [
                              Container(
                                // height: 100,
                                  color: Colors.white,
                                //   aspectRatio: 2,
                                  child: Image.network(
                                    _products[index]["product-img"][0],
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text("${_products[index]["product-name"]}",style: TextStyle(fontSize: 24),),
                              ),
                              Text(
                                  "${_products[index]["product-price"].toString()}",style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      );
                    }),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: GridView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: _products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, childAspectRatio: 1,crossAxisSpacing: 10, mainAxisExtent: 200),
                      itemBuilder: (_, index) {
                        return GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      ProductDetails(_products[index]))),
                          child: Card(
                            elevation: 3,
                            child: Column(
                              children: [
                                Container(
                                  // height: 100,
                                    color: Colors.white,
                                    child: Image.network(
                                      _products[index]["product-img"][0],
                                    )),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text("${_products[index]["product-name"]}",style: TextStyle(fontSize: 24),),
                                ),
                                Text(
                                    "${_products[index]["product-price"].toString()}",style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                        );
                      }),
              ),
            ],
        ),
      )),
    );
  }
}
