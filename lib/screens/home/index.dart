import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text("Vubon Roy"),
              accountEmail: new Text("vubon.roy@gmail.com"),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.redAccent,
                //child: new Text("V"),
                backgroundImage: new AssetImage('assets/images/vubon.jpg'),
              ),
              decoration: new BoxDecoration(color: const Color(0xff271f56)),
            ),
            new ListTile(
              title: new Text(
                "Bill Pay",
                style: new TextStyle(color: Colors.black),
              ),
              trailing: new Icon(
                Icons.payment,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed("/BillPay");
              },
            ),
            new ListTile(
              title: new Text(
                "Send Money",
                style: new TextStyle(color: Colors.black),
              ),
              trailing: new Icon(
                Icons.attach_money,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed("/SendMoney");
              },
            ),
            new ListTile(
              title: new Text(
                "Balance Query",
                style: new TextStyle(color: Colors.black),
              ),
              trailing: new Icon(
                Icons.search,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed("/Balance");
              },
            ),
            new ListTile(
              title: new Text(
                "QR Code",
                style: new TextStyle(color: Colors.black),
              ),
              trailing: new Icon(
                Icons.fingerprint,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed("/QRCode");
              },
            ),
            new Divider(
              color: Colors.grey,
            ),
            new ListTile(
              title: new Text(
                "Close",
                style: new TextStyle(color: Colors.black),
              ),
              trailing: new Icon(
                Icons.close,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      body: GridView.count(crossAxisCount: 3, children: <Widget>[
        new Card(
          color: const Color(0xff271f56),
          borderOnForeground: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          margin: EdgeInsets.all(10),
          child: new Center(
              child: new ListTile(
            title: new Text(
              "Send Money",
              style: TextStyle(color: Colors.white, fontSize: 14.0),
              textAlign: TextAlign.center,
            ),

            // trailing: new Icon(Icons.attach_money),
            onTap: () {
              Navigator.of(context).pushNamed("/SendMoney");
            },
          )),
        ),
        new Card(
          color: const Color(0xff271f56),
          borderOnForeground: true,
          semanticContainer: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          margin: EdgeInsets.all(10),
          child: new Center(
              child: new ListTile(
            title: new Text(
              "Bill Pay",
              style: TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            onTap: () {
              Navigator.of(context).pushNamed("/BillPay");
            },
          )),
        ),
        new Card(
          color: const Color(0xff271f56),
          borderOnForeground: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          margin: EdgeInsets.all(10),
          child: new Center(
              child: new ListTile(
            title: new Text(
              "Balance Query",
              style: TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            // trailing: new Icon(Icons.attach_money),
            onTap: () {
              Navigator.of(context).pushNamed("/Balance");
            },
          )),
        ),
        new Card(
          color: const Color(0xff271f56),
          borderOnForeground: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          margin: EdgeInsets.all(10),
          child: new Center(
              child: new ListTile(
            title: new Text(
              "QR Code",
              style: TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            // trailing: new Icon(Icons.attach_money),
            onTap: () {
              Navigator.of(context).pushNamed("/QRCode");
            },
          )),
        ),
      ]),
    );
  }
}
