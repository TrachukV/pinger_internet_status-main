import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinger_internet_status/pinger_internet_status.dart';

void main() {
  final PingerInternetStatus pingerInternetStatus = PingerInternetStatus(
    timeOut: 2,
    logger: true,
    hosts: ['google.com', 'facebook.com'],
  );
  runApp(PingerExample(
    pingerInternetStatus: pingerInternetStatus,
  ));
}

class PingerExample extends StatelessWidget {
  const PingerExample({
    super.key,
    required this.pingerInternetStatus,
  });

  final PingerInternetStatus pingerInternetStatus;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PingerStatus>(
      stream: pingerInternetStatus.status,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active &&
            snapshot.hasData) {
          return MaterialApp(
              title: 'Pinger Example',
              home: switch (snapshot.data) {
                PingerStatus.connected => const Material(
                    child: Center(
                      child: Text(
                        'Has Internet',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.activeBlue,
                        ),
                      ),
                    ),
                  ),
                _ => const Material(
                    child: Center(
                      child: Text(
                        'No Internet',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.activeBlue,
                        ),
                      ),
                    ),
                  ),
              });
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
