import 'dart:isolate';

class IsolateData {
  final SendPort sendPort;
  final List<String> urls;
  final int timeOut;
  final bool logger;

  IsolateData(
    this.sendPort,
    this.urls,
    this.timeOut,
    this.logger,
  );
}
