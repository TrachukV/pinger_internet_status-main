import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'package:http/http.dart' as http;

import 'isolate_data.dart';

// Enum to represent internet connection status.
enum PingerStatus { connected, disconnected }

class PingerInternetStatus {
  // Singleton instance.
  static final PingerInternetStatus _instance =
      PingerInternetStatus._internal();

  // URLs to ping for checking internet connectivity.
  List<String> urls = [];

  // Timeout for each ping request in seconds.
  int timeOut = 2;

  bool logger = false;

  // Stream controller to manage internet status updates.
  late final StreamController<PingerStatus> _statusController;

  // Isolate for running ping checks asynchronously.
  Isolate? _isolate;

  // Receive port for communication with the isolate.
  ReceivePort? _receivePort;

  // Factory constructor to access the singleton instance.
  factory PingerInternetStatus({
    required List<String> urls,
    int timeOut = 2,
    bool logger = false,
  }) {
    _instance.urls = urls;
    _instance.logger = logger;
    _instance.timeOut = timeOut;
    return _instance;
  }

  // Internal constructor for initializing the stream controller and listeners.
  PingerInternetStatus._internal() {
    _statusController = StreamController<PingerStatus>.broadcast(onListen: () {
      startMonitoring();
    }, onCancel: () {
      stopMonitoring();
    });
  }

  // Starts monitoring the internet connection by creating an isolate.
  void startMonitoring() async {
    _receivePort = ReceivePort();
    IsolateData isolateData =
        IsolateData(_receivePort!.sendPort, urls, timeOut, logger);
    _isolate = await Isolate.spawn(_checkPing, isolateData);
    _receivePort!.listen((dynamic data) {
      if (data is SendPort) {
        // Sending URLs and timeout to the isolate once it's ready.
        data.send([urls, timeOut]);
      } else if (data is PingerStatus) {
        // Updating the stream with the current internet status.
        _statusController.add(data);
      }
    });
  }

  // Static method that runs in an isolate to check internet connectivity.
  static void _checkPing(IsolateData data) async {
    ReceivePort isolateReceivePort = ReceivePort();
    // Immediately send back the ReceivePort's SendPort to establish communication.
    data.sendPort.send(isolateReceivePort.sendPort);

    isolateReceivePort.listen((dynamic message) async {
      if (message is List<dynamic>) {
        List<String> urls = message[0] as List<String>;
        int timeOut = message[1] as int;
        while (true) {
          bool isConnected = false;
          for (String url in urls) {
            try {
              final DateTime startTime = DateTime.now();
              final http.Response response = await http
                  .get(Uri.parse(url))
                  .timeout(Duration(seconds: timeOut));
              final DateTime endTime = DateTime.now();
              final int ping = endTime.difference(startTime).inMilliseconds;

              if (response.statusCode >= 200 && response.statusCode < 400) {
                if (data.logger) log('🔄Ping: $ping ms');
                data.sendPort.send(PingerStatus.connected);
                isConnected = true;
                // Continue to check the next URLs even if one is successful.
              }
            } catch (_) {
              // If there's an exception, consider it as disconnected.
              data.sendPort.send(PingerStatus.disconnected);
              if (data.logger) log(' 🟥Status: Disconnected');
            }
            await Future.delayed(Duration(seconds: timeOut));
          }

          // If none of the URLs are reachable, consider as disconnected.
          if (!isConnected) {
            data.sendPort.send(PingerStatus.disconnected);
          }

          // Wait before checking the URLs again.
          await Future.delayed(Duration(seconds: timeOut));
        }
      }
    });
  }

  // Stops the monitoring process and cleans up resources.
  void stopMonitoring() {
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _receivePort?.close();
    _receivePort = null;
  }

  // Exposes the internet status updates as a stream.
  Stream<PingerStatus> get status => _statusController.stream;
}
