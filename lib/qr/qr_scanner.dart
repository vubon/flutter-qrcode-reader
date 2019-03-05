import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//Third Party libs

import 'package:barcode_scan/barcode_scan.dart';
import 'package:location/location.dart';
import 'package:device_info/device_info.dart';





class QRScanner extends StatefulWidget{
  @override
  _QRScanner createState() => new _QRScanner();
}

class _QRScanner extends State<QRScanner>{


  // For QR Code
  String qrCode = "";
  String responseData = "";

  // for geolocation
  LocationData _startLocation;
  Location _location = new Location();

  // for device information
  static final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  @override
  initState(){
    super.initState();
    initPlatformState();
    _getCoordinates();
    scan();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Container(

        )
      ),
    );
  }

  void postData() async {
    Map data = {
      "qrcode": qrCode,
      "lat": _startLocation.latitude,
      "long": _startLocation.longitude,
      "deviceInfo": _deviceData,
    };
    //print(data);
    String body = json.encode(data);
    Map headers = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };
    http.Response response = await http.post(
      // Uri.encodeFull("http://192.168.10.106:8000/api/v1/create/"),
        Uri.encodeFull("http://192.168.1.201:8989/validate/qr-code/"),
        body: body,
        headers: headers
    );
    //print(response.body);

    String responseData = response.body;
    print('response: $responseData');
    setState(() => this.responseData = responseData);
  }

  Future scan() async {
    try {
      String qrCode = await BarcodeScanner.scan();
      setState(() => this.qrCode = qrCode);
      // call the post function here
      postData();
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.qrCode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.qrCode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.qrCode =
      'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.qrCode = 'Unknown error: $e');
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  // Getting Geo Location of user
  _getCoordinates() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    LocationData coordinates;
    try {
      coordinates = await _location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == "LOCATION DISABLED") {
        showDialog(
          context: context,
          child: new AlertDialog(
            title: const Text("Location disabled"),
            content: const Text(
                """Location is disabled on this device. Please enable it and try again."""),
          ),
        );
      }
      coordinates = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _startLocation = coordinates;
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
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      //'version.securityPatch': build.version.securityPatch,
      //'version.sdkInt': build.version.sdkInt,
      //'version.release': build.version.release,
      //'version.previewSdkInt': build.version.previewSdkInt,
      //'version.incremental': build.version.incremental,
      //'version.codename': build.version.codename,
      //'version.baseOS': build.version.baseOS,
      //'board': build.board,
      //'bootloader': build.bootloader,
      'brand': build.brand,
      //'device': build.device,
      //'display': build.display,
      //'fingerprint': build.fingerprint,
      //'hardware': build.hardware,
      //'host': build.host,
      //'id': build.id,
      //'manufacturer': build.manufacturer,
      'model': build.model,
      //'product': build.product,
      //'supported32BitAbis': build.supported32BitAbis,
      //'supported64BitAbis': build.supported64BitAbis,
      //'supportedAbis': build.supportedAbis,
      //'tags': build.tags,
      //'type': build.type,
      //'isPhysicalDevice': build.isPhysicalDevice,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      //'localizedModel': data.localizedModel,
      //'identifierForVendor': data.identifierForVendor,
      //'isPhysicalDevice': data.isPhysicalDevice,
      //'utsname.sysname:': data.utsname.sysname,
      //'utsname.nodename:': data.utsname.nodename,
      //'utsname.release:': data.utsname.release,
      //'utsname.version:': data.utsname.version,
      //'utsname.machine:': data.utsname.machine,
    };
  }

}