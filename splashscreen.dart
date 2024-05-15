import 'package:flutter/material.dart';
import 'package:majorproscenelens/screens/homescreen.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    _navigatehome();
  }

  _navigatehome() async {
    await Future.delayed(Duration(milliseconds: 2500), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/bg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search,
                color: Colors.white,
                size: 350.0,
              ),
              Center(
                  child: Text(
                "SceneLens",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 50.0,
                    fontFamily: 'roboto',
                    fontWeight: FontWeight.bold),
              )),
            ],
          ),
        ),
      ),

      // decoration: new BoxDecoration(
      //     shape: BoxShape.circle,
      //     image: new DecorationImage(
      //       image: const AssetImage("assets/images/magni.jpg"),
      //     )),
    );
  }
}
