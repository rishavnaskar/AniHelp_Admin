import 'package:anihelp_admin/screens/navbar/navbar_tabs/media.dart';
import 'package:anihelp_admin/screens/navbar/navbar_tabs/users.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  var padding = EdgeInsets.symmetric(horizontal: 18, vertical: 7);
  double gap = 10;
  List body = [UserScreen(), MediaScreen()];
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView.builder(
          controller: _pageController,
          onPageChanged: (page) {
            setState(() {
              _selectedIndex = page;
            });
          },
          itemCount: 2,
          itemBuilder: (context, position) {
            return body[position];
          }),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(100)),
            boxShadow: [
              BoxShadow(
                  spreadRadius: -10,
                  blurRadius: 60,
                  offset: Offset(0, 25),
                  color: Colors.black.withOpacity(0.4))
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(3),
            child: GNav(
              curve: Curves.fastOutSlowIn,
              duration: Duration(milliseconds: 900),
              tabs: [
                navBarButtons(Icons.people, "Users", Color(0xff00a86b)),
                navBarButtons(Icons.playlist_play, "Media", Color(0xff00a86b)),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
                _pageController.jumpToPage(index);
              },
              debug: false,
              haptic: true,
              rippleColor: Color(0xff1b4d3e),
            ),
          ),
        ),
      ),
    );
  }

  navBarButtons(IconData iconData, String text, Color backgroundColor) {
    return GButton(
      icon: iconData,
      iconColor: Colors.black,
      iconActiveColor: Color(0xff1b4d3e),
      text: text,
      textStyle: TextStyle(fontFamily: 'CarterOne', letterSpacing: 1.5),
      backgroundColor: backgroundColor.withOpacity(0.3),
      iconSize: 24,
      padding: padding,
      gap: gap,
    );
  }
}
