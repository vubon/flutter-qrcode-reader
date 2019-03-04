import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class SendMoney extends StatefulWidget {
  @override
  _SendMoney createState() => new _SendMoney();
}

class _SendMoney extends State<SendMoney> {
  final TextEditingController _controller = new TextEditingController();
  String _inputTextError;
  String responseData = "";

  String dropdownValue;
  List<String> _accountList = new List<String>();

  String members;
  List<String> _memberList = new List<String>();

  @override
  void initState() {

    // account list
    _accountList.addAll([
      "Select account",
      "0006-0000000001",
      "0006-0000000002",
      "0006-0000000003",
      "0006-0000000004"
    ]);
    dropdownValue = _accountList.elementAt(0);

    // member list
    _memberList.addAll([
      "Select Member",
      "Vubon(01737388296)",
      "Sharif(01737573157)",
      "Rana(0176985478)",
      "No One(01277458947)",
    ]);
    members = _memberList.elementAt(0);
    super.initState();
  }

  void postData() async {
    Map data = {
      "amount": _controller.text,
      "account": dropdownValue,
    };
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
    print(response.body);

    String responseData = response.body;
    //print('Response $responseData');
    setState(() => this.responseData = responseData);
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new Text("Send Money"),
      ),
      body: new Container(
        padding: const EdgeInsets.all(20.0),
        child: new Column(
          children: <Widget>[
            new Container(
              child: new TextField(
                controller: _controller,
                autofocus: true,
                keyboardType: TextInputType.number,
                maxLength: 10,
                decoration: new InputDecoration(
                  hintText: 'Enter your amount',
                  errorText: _inputTextError,
                  icon: new Icon(Icons.attach_money),
                  filled: true,
                ),
              ),
            ),
            // For account list
            new Container(
                //width: MediaQuery.of(context).size.width,
                //padding: const EdgeInsets.all(5.0),
                child: new DropdownButton<String>(
                    //style: new TextStyle(color: Colors.deepPurple, fontSize: 14.0),
                    value: dropdownValue,
                    onChanged: (String account) {
                      setState(() {
                        if (account != null) {
                          dropdownValue = account;
                        }
                      });
                    },
                    items: _accountList.map((String account) {
                      return new DropdownMenuItem(
                        value: account,
                        child: new Container(
                          width: MediaQuery.of(context).size.width - 80.0,
                          padding: const EdgeInsets.all(5.0),
                          child: new Row(
                            children: <Widget>[
                              new Text(account),
                            ],
                          ),
                        ),
                      );
                    }).toList()
                )
            ),

            // Select Member
            new Container(
              child: new DropdownButton<String>(
                  value: members,
                  onChanged: (String member){
                    setState(() {
                      if(member != null){
                        members = member;
                      }
                    });
                  },
                  items: _memberList.map((String member){
                    return new DropdownMenuItem(
                        value: member,
                        child: new Container(
                            width: MediaQuery.of(context).size.width - 80.0,
                            child: new Row(
                              children: <Widget>[
                                new Text(member),
                              ],
                            )
                        ),
                    );
                  }).toList(),
              ),
            ),


            // Submit button
            new Container(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
              child: new RaisedButton(
                onPressed: () {
                  // perform the button action
                  String amount = _controller.text;
                  String account = dropdownValue;
                  showDialog(
                      context: context,
                      child: new AlertDialog(
                        title: new Text('Are you sure?'),
                        content: new Text("Want to send this amount: $amount TK. from this $account"),
                        actions: <Widget>[
                          new RaisedButton(
                              onPressed: (){
                                // Perform the confirm action
                                postData();
                                Navigator.of(context).pop('/SendMoney');
                              }, 
                              child: new Text("Confirm"),
                              color: Colors.deepPurple,
                              textColor: Colors.white,

                          ),
                          
                          new RaisedButton(
                              onPressed: (){
                                // Perform the cancel action
                                Navigator.of(context).pop();

                              }, 
                              child: new Text('Cancel'),
                              color: Colors.red,
                              textColor: Colors.white,
                          )
                        ],
                      )
                  );
                },
                //label: const Text('Send Money'),
                //icon: new Icon(Icons.send,textDirection: TextDirection.ltr,),
                //color: Colors.deepPurple[900],
                color: const Color(0xff271f56),
                elevation: 5.0,
                textColor: Colors.white,
                child: new Text("Send Moeny"),
                animationDuration: const Duration(microseconds: 1000),
                splashColor: Colors.deepPurple,
                padding: const EdgeInsets.all(10.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
