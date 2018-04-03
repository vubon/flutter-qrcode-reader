import 'package:flutter/material.dart';


class BillPay  extends StatelessWidget{

	@override
	Widget build(BuildContext context){
		return new Scaffold(
			backgroundColor: Colors.white,
			appBar: new AppBar(
				title: new Text("Bill Pay"),
			), //AppBar

			body: new Center(
				child: new Text("Bill Pay Page"),
			),
		);
	}
}