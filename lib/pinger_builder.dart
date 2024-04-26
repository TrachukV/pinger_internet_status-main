import 'package:flutter/material.dart';
import 'pinger_internet_status.dart';

class PingerStatusListener extends StatelessWidget {
  final PingerInternetStatus statusChecker;
  final Widget Function(PingerStatus) builder;

  const PingerStatusListener({
    Key? key,
    required this.statusChecker,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PingerStatus>(
      stream: statusChecker.status,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active &&
            snapshot.hasData) {
          return builder(snapshot.data!);
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
