import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BluetoothApp(),
    );
  }
}

class BluetoothApp extends StatefulWidget {
  @override
  _BluetoothAppState createState() => _BluetoothAppState();
}

class _BluetoothAppState extends State<BluetoothApp> {
  BluetoothDevice _device;
  List<BluetoothDevice> _devicesList = [];
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPairedDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("luetooth"),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          DropdownButton(
            items: _getDeviceItems(),
            onChanged: (value) => setState(() => _device = value),
            value: _devicesList.isNotEmpty ? _device : null,
          ),
          RaisedButton(
            onPressed: () => _connect(),
            child: Text("Connect"),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devicesList.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    // To get the list of paired devices
    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    // Store the [devices] list in the [_devicesList] for accessing
    setState(() {
      _devicesList = devices;
    });
  }

  void _connect() async {
    await BluetoothConnection.toAddress(_device.address).then((_connection) {
      print('Connected to the device');
    }).catchError((error) {
      print('Cannot connect, exception occurred');
      print(error);
    });
  }
}

///////////////////////////////////////////////////////

// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: BluetoothApp(),
//     );
//   }
// }

// class BluetoothApp extends StatefulWidget {
//   @override
//   _BluetoothAppState createState() => _BluetoothAppState();
// }

// class _BluetoothAppState extends State<BluetoothApp> {
//   BluetoothDevice device;
//   BluetoothState state;
//   BluetoothDeviceState deviceState;
//   var scanSubscription;
//   FlutterBlue bluetoothInstance = FlutterBlue.instance;

//   void initState() {
//     super.initState();
// //checks bluetooth current state
//     FlutterBlue.instance.state.listen((state) {
//       if (state == BluetoothState.off) {
// //Alert user to turn on bluetooth.
//       } else if (state == BluetoothState.on) {
// //if bluetooth is enabled then go ahead.
// //Make sure user's device gps is on.
//         scanForDevices();
//       }
//     });
//   }

//   void scanForDevices() async {
//     scanSubscription = bluetoothInstance.scan().listen((scanResult) async {
//       if (scanResult.device.name == "your_device_name") {
//         print("found device");
// //Assigning bluetooth device
//         device = scanResult.device;
// //After that we stop the scanning for device
//         stopScanning();
//       }
//     });
//   }

//   void stopScanning() {
//     bluetoothInstance.stopScan();
//     scanSubscription.cancel();
//   }

//   connectToDevice() async {
// //flutter_blue makes our life easier
//     await device.connect();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Bluetooth"),
//       ),
//     );
//   }
// }
