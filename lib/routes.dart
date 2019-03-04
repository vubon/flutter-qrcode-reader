import 'package:flutter/material.dart';

// local page import

import 'package:qrcode/screens/home/index.dart';

class Routes{
  Routes(){
    runApp(new MaterialApp(
      title: "JBL Bank Ltd.",
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primaryColor: const Color(0xff271f56),
      ),
      home: new MyHomePage(title: 'JBL Bank Ltd.',),


    ));
  }
}