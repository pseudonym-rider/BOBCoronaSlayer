import 'dart:async';
import 'dart:io' show Platform;

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:BOB_corona_slayer/services/commuication.dart';

class ScanPage extends StatefulWidget {
  static String routeName = "/qr_scan";
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  var _numberOfCameras = 0;
  var _selectedCamera = -1;
  String qrCodeResult = "";
  bool _isScanning = false;
  bool _isvaild = false;
  StreamSubscription scanHandler;
  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _numberOfCameras = await BarcodeScanner.numberOfCameras;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scanner"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: _isScanning
            ? Center(
                child: _isvaild
                    ? Text(
                        "인증되었습니다.",
                        style: TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.bold),
                      )
                    : Text(
                        "유효하지않습니다. 다시 스캔해주세요.",
                        style: TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.bold),
                      ))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    "스캔을 시작하시려면 아래 버튼을 눌러주세요.",
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    qrCodeResult,
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Column(
                    children: <Widget>[
                      RadioListTile(
                        onChanged: (v) => setState(() => _selectedCamera = v),
                        value: 0,
                        title: Text("후면 카메라"),
                        groupValue: _selectedCamera,
                      ),
                      _numberOfCameras > 1
                          ? RadioListTile(
                              onChanged: (v) =>
                                  setState(() => _selectedCamera = v),
                              value: 1,
                              title: Text("전면 카메라"),
                              groupValue: _selectedCamera,
                            )
                          : Container(),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  FlatButton(
                    padding: EdgeInsets.all(15.0),
                    onPressed: () async {
                      ScanResult result;
                      result = await scanQRCode();
                      if (result.rawContent != "") {
                        _isvaild = await readQRCode(result.rawContent);
                        print("_isvalid: $_isvaild");
                        setState(() {
                          _isScanning = true;
                        });
                        await Future.delayed(Duration(seconds: 1));
                      }
                      while (result.rawContent != "") {
                        result = await scanQRCode();
                        if (result.rawContent == "") {
                          setState(() {
                            _isScanning = false;
                          });
                          break;
                        }
                        _isvaild = await readQRCode(result.rawContent);
                        print("_isvalid: $_isvaild");
                        setState(() {});
                        await Future.delayed(Duration(seconds: 1));
                      }
                    },
                    child: Text(
                      "Open Scanner",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.green, width: 3.0),
                        borderRadius: BorderRadius.circular(20.0)),
                  )
                ],
              ),
      ),
    );
  }

  Future<ScanResult> scanQRCode() async {
    try {
      print(_selectedCamera);
      var options = ScanOptions(
        strings: {
          "cancel": "cancel",
          "flash_on": "flash on",
          "flash_off": "flash off"
        },
        restrictFormat: [BarcodeFormat.qr], //selectedFormats,
        useCamera: _selectedCamera,
        autoEnableFlash: false,
        android: AndroidOptions(
          aspectTolerance: 0,
          useAutoFocus: true,
        ),
      );

      var result = await BarcodeScanner.scan(options: options);

      return result;
    } on PlatformException catch (e) {
      var result = ScanResult(
        type: ResultType.Error,
        format: BarcodeFormat.unknown,
      );

      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          result.rawContent = 'camera permission error';
        });
      } else {
        result.rawContent = 'Unknown error';
      }
      return result;
    }
  }
  //its quite simple as that you can use try and catch staatements too for platform exception
}
