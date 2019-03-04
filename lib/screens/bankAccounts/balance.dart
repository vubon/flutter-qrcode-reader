import 'package:flutter/material.dart';

List accounts = ['0006-0000000001', '0006-0000000002', '0006-0000000003'];

class BalanceCard extends StatefulWidget{
  final String account;
  BalanceCard({this.account});

  @override
  _BalanceSateCard createState() => new _BalanceSateCard(account: account);
}



class _BalanceSateCard extends State<BalanceCard>{
  final String account;
  Key key = new Key('default');
  _BalanceSateCard({this.account});


  @override
  void initState() {
    super.initState();
    key = new Key(account);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle descriptionStyle = theme.textTheme.subhead;
    return new SafeArea(
      top: false,
      bottom: false,
      child: new Dismissible(
        key: key,
        onDismissed: (DismissDirection dir) {
          accounts.removeLast();
        },
        child: new Container(
          padding: const EdgeInsets.all(8.0),
          height: 280.0,
          child: new Card(
            color: Colors.white,
            elevation: 3.0,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new SizedBox(
                  height: 184.0,
                  child: new Stack(
                    children: <Widget>[
                      new Positioned.fill(
                        child: new Image.asset('assets/images/logo-symbol.png'),
                      ),
                    ],
                  ),
                ),
                new Expanded(
                  child: new Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                    child: new DefaultTextStyle(
                      style: descriptionStyle,
                      child: new Column(
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: new Text(
                              "Account - $account",

                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Balance extends StatefulWidget{
  @override
  _Balance createState() => new _Balance();
}


class _Balance extends State<Balance>{


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new Text("Balance Query"),
      ),

      body: new Stack(
        children: accounts.map((dynamic account){
          return new Container(
            child: new BalanceCard(
              account: account,
            ),
          );
        }).toList(),
      ),

    );
  }
}
