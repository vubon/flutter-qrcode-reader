import 'package:flutter/material.dart';

// Local file import
import 'package:qrcode/qr/qr_scanner.dart';
import 'package:qrcode/qr/qr_generator.dart';



class QRCode extends StatefulWidget{
  @override
  _QRCode createState() => new _QRCode();
}


class _QRCode extends State<QRCode>{


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home:new DefaultTabController(
          length: 2,
          child: new Scaffold(
            appBar: new AppBar(
              backgroundColor: const Color(0xff271f56),
              title: new Text('QR Code'),
              bottom: new TabBar(
                  tabs:[
                    new Tab(text: 'Scanner', icon: new Icon(Icons.scanner),),
                    new Tab(text: 'Generator', icon: new Icon(Icons.create),),
                  ]
              ),
            ),
            body: new TabBarView(
                children: <Widget>[
                  new QRScanner(),
                  new QRCodeGenerator(),
                ]
            ),
          ),
      )
    );
  }
}