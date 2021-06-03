import 'package:anihelp_admin/screens/navbar/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: _isLoading,
        color: Color(0xff1b4d3e),
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xff1b4d3e), Color(0xff00a86b)])),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1)),
                Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("AniHelp Admin",
                              style: TextStyle(
                                  fontSize: 40,
                                  letterSpacing: 2,
                                  fontFamily: "CarterOne",
                                  color: Colors.white)),
                          SizedBox(width: 20),
                          Lottie.asset("assets/19979-dog-steps.json",
                              height: 30, width: 30),
                        ],
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Text(
                          "Admin version",
                          style: TextStyle(
                            fontFamily: "CarterOne",
                            letterSpacing: 2,
                            color: Colors.grey[400],
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Flexible(
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2)),
                Lottie.asset("assets/24278-pet-lovers.json",
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width),
                Flexible(
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(vertical: 10)),
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xff1b4d3e)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)))),
                    onPressed: () async {
                      await FirebaseAuth.instance.signInAnonymously();
                      return Navigator.push(context,
                          CupertinoPageRoute(builder: (context) => NavBar()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Let\'s proceed",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Montserrat",
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(width: 20),
                        Lottie.asset("assets/next.json", height: 10)
                      ],
                    ),
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
