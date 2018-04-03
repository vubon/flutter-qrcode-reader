import 'package:flutter/material.dart';


class Balance  extends StatelessWidget{

	@override
	Widget build(BuildContext context){
		return new Scaffold(
			backgroundColor: Colors.white,
			appBar: new AppBar(
				title: new Text("Balance Query"),
			), //AppBar

			body: new Center(
				child: new Text("Balance Query Page"),
			),
		);
	}
}