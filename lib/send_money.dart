import 'package:flutter/material.dart';


class SendMoney  extends StatelessWidget{

	@override
	Widget build(BuildContext context){
		return new Scaffold(
			backgroundColor: Colors.white,
			appBar: new AppBar(
				title: new Text("Send Money"),
			), //AppBar

			body: new Center(
				child: new Text("Send Money Page"),
			),
		);
	}
}