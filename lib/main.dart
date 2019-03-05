import 'package:flutter/material.dart';

// local page import
import 'package:qrcode/screens/home/index.dart';
import 'package:qrcode/screens/familyWallet/send_money.dart';
import 'package:qrcode/screens/bankAccounts/balance.dart';
import 'package:qrcode/screens/billPayments/bill_pay.dart';
import 'package:qrcode/qr_generator_old.dart';
import 'package:qrcode/qr/qr_main.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  MyApp({Key key , this.title}): super(key: key);
  final String title;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(
          //primarySwatch: Colors.indigo[900],
          // canvasColor: Colors.indigo[400]
          primaryColor: const Color(0xff271f56),
        ),
        home: new MyHomePage(title: 'Demo Bank Ltd.'),
        routes: <String, WidgetBuilder>{
          "/SendMoney": (BuildContext context) => new SendMoney(),
          "/Balance": (BuildContext context) => new Balance(),
          "/BillPay": (BuildContext context) => new BillPay(),
          "/QRCodeGenerator": (BuildContext context) => new QRCodeGenerator(),
          "/QRCode": (BuildContext context) => new QRCode(),

        }
    );
  }
}

