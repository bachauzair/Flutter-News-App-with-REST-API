import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newss/HomePage.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer (const Duration(seconds: 5), () =>
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()))

    );
  }



  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;




    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: MediaQuery.sizeOf(context).height *.2,),
          Image.asset('Assets/news2.jpg',
          fit: BoxFit.cover,
            height: height * .5,
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height *.04,),
          Text('News Headlines', style: GoogleFonts.anton(letterSpacing: .8),),

          SpinKitChasingDots(
              color: Colors.blue,
            size: 50,
          )

        ],
      ),
    );
  }
}
