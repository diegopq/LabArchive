import 'dart:io';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  static final bool isIOS = Platform.isIOS;

  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 200);

  AnimationController _controller;
  Animation<double> _scaleAnimation;

  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          menu(context),
          dashboard(context),
        ],
      ),
    );
  }

  Widget menu(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: screenWidth / 1.7,
          color: Colors.red,
          child: Center(
            child: Text('menu'),
          ),
        ),
      ),
    );
  }

  Widget dashboard(BuildContext context) {
    return AnimatedPositioned(
      duration: duration,
      top: 0,
      bottom: 0,
      left: isCollapsed ? 0 : 0.5 * screenWidth,
      right: isCollapsed ? 0 : -0.3 * screenWidth,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTap: () {
            if (!isCollapsed) {
              setState(() {
                isCollapsed = true;
                _controller.reverse();
              });
            }
          },
          child: Material(
            elevation: 2.0,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF82E6F4),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      width: double.infinity,
                      height: 90.0,
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: 40.0,
                        ),
                        Row(
                          children: <Widget>[
                            IconButton(
                              padding: EdgeInsets.only(left: 20.0),
                              icon: Icon(
                                IconData(0xe900, fontFamily: 'MenuIcon'),
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (isCollapsed) {
                                    _controller.forward();
                                  } else {
                                    _controller.reverse();
                                  }
                                  isCollapsed = !isCollapsed;
                                  print(isCollapsed);
                                });
                              },
                            ),
                            SizedBox(
                              width: screenWidth / 5,
                            ),
                            Text(
                              'DashBoard',
                              style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2.0,
                                  color: Colors.white),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: ClampingScrollPhysics(),
                  child: Container(
                    color: Colors.red,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
