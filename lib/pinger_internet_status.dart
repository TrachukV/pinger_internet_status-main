import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'isolate_data.dart';

// Enum to represent internet connection status.
enum PingerStatus { connected, disconnected }

class PingerInternetStatus {
  // Singleton instance.
  static final PingerInternetStatus _instance =
      PingerInternetStatus._internal();

  // URLs to ping for checking internet connectivity.
  List<String> _hosts = [];

  // Timeout for each ping request in seconds.
  int _timeOut = 2;

  bool _logger = false;

  // Stream controller to manage internet status updates.
  late final StreamController<PingerStatus> _statusController;

  // Isolate for running ping checks asynchronously.
  Isolate? _isolate;

  // Receive port for communication with the isolate.
  ReceivePort? _receivePort;

  // Factory constructor to access the singleton instance.
  factory PingerInternetStatus({
    required List<String> hosts,
    int timeOut = 2,
    bool logger = false,
  }) {
    _instance._hosts = hosts;
    _instance._logger = logger;
    _instance._timeOut = timeOut;
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
        IsolateData(_receivePort!.sendPort, _hosts, _timeOut, _logger);
    _isolate = await Isolate.spawn(_checkPing, isolateData);
    _receivePort!.listen((dynamic data) {
      if (data is SendPort) {
        // Sending URLs and timeout to the isolate once it's ready.
        data.send([_hosts, _timeOut]);
      } else if (data is PingerStatus) {
        // Updating the stream with the current internet status.
        _statusController.add(data);
      }
    });
  }

  // Static method that runs in an isolate to check internet connectivity.

  static void _checkPing(IsolateData data) async {
    ReceivePort isolateReceivePort = ReceivePort();
    data.sendPort.send(isolateReceivePort.sendPort);

    isolateReceivePort.listen((dynamic message) async {
      if (message is List<dynamic>) {
        List<String> hostnames = message[0] as List<String>;
        int timeOut = message[1] as int;

        while (true) {
          bool isConnected = false;
          for (String hostname in hostnames) {
            try {
              final List<InternetAddress> result =
                  await InternetAddress.lookup(hostname)
                      .timeout(Duration(seconds: timeOut));
              if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                if (data.logger) log('🔄DNS lookup success for $hostname');
                data.sendPort.send(PingerStatus.connected);
                isConnected = true;
                break;
              }
            } catch (_) {
              if (data.logger) log(' 🟥DNS lookup failed for $hostname');
            }
          }

          if (!isConnected) {
            data.sendPort.send(PingerStatus.disconnected);
          }

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
