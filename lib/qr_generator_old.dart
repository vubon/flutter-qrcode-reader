import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

// for generation QR Code
import 'package:qr_flutter/qr_flutter.dart';


class QRCodeGenerator extends StatefulWidget{
  @override
  _QRCodeGenerator createState() => new _QRCodeGenerator();
}


class _QRCodeGenerator extends State<QRCodeGenerator>{

//  static const double _topSectionTopPadding = 50.0;
//  static const double _topSectionBottomPadding = 20.0;
//  static const double _topSectionHeight = 50.0;


  String _dataString = '1';  //= "{'amount': '2000', 'account':'1234578968574859', 'bank': 'Jamuna bank ltd'}";
  //String _dataString = "{'amount': '2000', 'account':'1234578968574859', 'bank': 'Jamuna bank ltd', 'connectID': '01737388296', 'type': 'payment', 'hello': 'hello world', 'bkash': 'bkash12354'}";
  String _inputErrorText;
  String responseData = "";

  final TextEditingController _controller = new TextEditingController();


  String _value = '';

  List<String> _values = new List<String>();

  @override
  void initState() {
    _values.addAll(["0006-0000000001", "0006-0000000002", "0006-0000000003"]);
    _value = _values.elementAt(0);
    super.initState();
  }

  void _onChanged(String value){
    setState((){
      _value = value;
    });
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new Text("QR Code Generator"),
      ),

      body: _contentWidget(),
      resizeToAvoidBottomPadding: true,

    );
  }

  @override
  didUpdateWidget(Widget oldWidget){
    super.didUpdateWidget(oldWidget);
    setState((){});
  }

  void postData() async {
    Map data = {
      "amount": _controller.text,
      "account": _value,
    };
    print(data);
    String body = json.encode(data);
    Map headers = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };
    http.Response response = await http.post(
      // Uri.encodeFull("http://192.168.10.106:8000/api/v1/create/"),
        Uri.encodeFull("http://192.168.1.201:8989/validate/qr-code/"),
        body: body,
        headers: headers);
    //print(response.body);

    String responseData = response.body;
    print('Response $responseData');
    setState(() => this.responseData = responseData);
  }

  // Content of the QR Generate page
  _contentWidget(){
    final bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Container(
          child: new TextFormField(
            validator: (val) => val.length >= 10 ? 'Amount is too big': null,
            autofocus: true,
            controller: _controller,
            keyboardType: TextInputType.number,
            //maxLines: 1,
            decoration: new InputDecoration(
              hintText: 'Enter Amount',
              border: new UnderlineInputBorder(),
              filled: true,
              icon: new Icon(Icons.attach_money),
              labelText: "Enter your amount",
              errorText: _inputErrorText,
            ),

          ),
          padding: const EdgeInsets.all(20.0),
        ),

        new Container(
          //width: MediaQuery.of(context).size.width - 50.0,
          padding: const EdgeInsets.all(20.0),
          child: new DropdownButton(

              value: _value,
              items: _values.map((String value){
                return new DropdownMenuItem(
                    value: value,
                    child: new Container(
                      width: MediaQuery.of(context).size.width - 100.0,
                      child: new Row(
                        children: <Widget>[
                          //new Icon(Icons.account_balance,),
                          new Text(value,),
                        ],
                      ),
                    )
                );
              }).toList(),
              onChanged: (String value){_onChanged(value);}
          ),
        ),

        new Container(
          child: new RaisedButton(
            onPressed: _buttonPress,
//            onPressed: () {
//              String _amount = _controller.text;
//              setState((){
//                _dataString = "{'amount': $_amount, 'account': $_value }";
//                _inputErrorText = null;
//              });
//
//              showDialog(
//                context: context,
//                child: new AlertDialog(
//                  title: new Text('What you typed'),
//                  content: new Text(_controller.text),
//                ),
//              );
//            },
            child: new Text("Generate"),
            color: Colors.redAccent,
            textColor: Colors.white,
          ),
        ),
        new Expanded(
          child: new Center(
            child: new QrImage(
                data: _dataString,
                size: 0.5 * bodyHeight,
                version: 15,
                onError: (ex){
                  print("QR Erorr - $ex");
                  setState((){
                    _inputErrorText = "Error ! message ";
                  });
                },
            ),
          ),
        ),
      ],
    );
  }

  void _buttonPress(){
     postData();
    _dataString = responseData;
  }
}