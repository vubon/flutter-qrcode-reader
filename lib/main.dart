import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:gps_coordinates/gps_coordinates.dart';
import 'package:device_info/device_info.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: new MyHomePage(title: 'QR Code Reader'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // for QRCode or barcode
  String barcode = "";
  // for geolocation
  Map<String, double> _coordinates = new Map();

  // for device information
  static final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  @override
  initState() {
    super.initState();
    _coordinates["lat"] = _coordinates["long"] = 0.0;
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(barcode),
            new Container(
              child: new RaisedButton(
                child: new Text('Scan'),
                textColor: Colors.white,
                color: Colors.deepPurpleAccent,
                onPressed: _buttonPress,
              ),
              padding: const EdgeInsets.all(8.0),
            ),

          ],
        ),
      ),
    );
  }

  void _buttonPress() {
    scan();
    _getCoordinates();
  }

  void postData() async {
    Map data = {
      "bardcode": barcode,
      "lat": _coordinates["lat"],
      "long": _coordinates["long"],
      "deviceInfo": _deviceData,
    };
    print(data);
    String body = json.encode(data);
    Map headers = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };
    http.Response response = await http.post(
        Uri.encodeFull("http://192.168.10.106:8000/api/v1/create/"),
        body: body,
        headers: headers
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
      // call the post function here
      postData();
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() =>
      this.barcode =
      'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  _getCoordinates() async {
    Map<String, double> coordinates;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      coordinates = await GpsCoordinates.gpsCoordinates;
    } on PlatformException catch (e) {
      if (e.code == "LOCATION DISABLED") {
        showDialog(
          context: context,
          child: new AlertDialog(
            title: const Text("Location disabled"),
            content: const Text(
                """Location is disabled on this device. Please enable it and try again."""),
            //actions: [
            //  new FlatButton(
            //    child: const Text("Ok"),
            //    onPressed: _emptyMethod,
            //  ),
            //],
          ),
        );
      }
      Map<String, double> placeholderCoordinates = new Map();
      placeholderCoordinates["lat"] = 0.0;
      placeholderCoordinates["long"] = 0.0;
      coordinates = placeholderCoordinates;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted)
      return;

    setState(() {
      _coordinates = coordinates;
    });
  }

  // Device information collection

//  static Future<List<String>> getDeviceDetails() async {
//    String deviceName;
//    String deviceVersion;
//    String identifier;
//    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
//    try {
//      if (Platform.isAndroid) {
//        var build = await deviceInfoPlugin.androidInfo;
//        deviceName = build.model;
//        deviceVersion = build.version.toString();
//      } else if (Platform.isIOS) {
//        var data = await deviceInfoPlugin.iosInfo;
//        deviceName = data.name;
//        deviceVersion = data.systemVersion;
//        identifier = data.identifierForVendor;//UUID for iOS
//      }
//    } on PlatformException {
//      print('Failed to get platform version');
//    }
//
////if (!mounted) return;
//    return [deviceName, deviceVersion, identifier];
//  }

  Future<Null> initPlatformState() async {
    Map<String, dynamic> deviceData;

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
    print(deviceData);
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }


}
