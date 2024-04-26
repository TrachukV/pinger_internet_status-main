import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinger_internet_status/pinger_internet_status.dart';
import 'package:untitled/example_bloc/bloc/connections_bloc.dart';
import 'package:untitled/example_bloc/utils/generate_string.dart';
import 'package:untitled/example_bloc/widgets/overlay_body.dart';

void main() {
  final PingerInternetStatus pingerInternetStatus = PingerInternetStatus(
    timeOut: 2,
    logger: true,
    hosts: ['google.com', 'facebook.com'],
  );
  final ConnectionsBloc connectionsBloc = ConnectionsBloc(pingerInternetStatus);
  runApp(PingerExample(
    connectionsBloc: connectionsBloc,
    pingerInternetStatus: pingerInternetStatus,
  ));
}

class PingerExample extends StatelessWidget {
  const PingerExample({
    super.key,
    required this.pingerInternetStatus,
    required this.connectionsBloc,
  });

  final PingerInternetStatus pingerInternetStatus;
  final ConnectionsBloc connectionsBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: connectionsBloc,
      child: const MaterialApp(
        title: 'Pinger Example',
        home: ConnectionCheckPage(),
      ),
    );
  }
}

class ConnectionCheckPage extends StatefulWidget {
  const ConnectionCheckPage({super.key});

  @override
  State<ConnectionCheckPage> createState() => _ConnectionCheckPageState();
}

class _ConnectionCheckPageState extends State<ConnectionCheckPage> {
  OverlayEntry? overlayEntry;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectionsBloc, ConnectionsState>(
      listener: (context, state) {
        switch (state.internetStatus) {
          case PingerStatus.connected:
            overlayEntry?.remove();
          case PingerStatus.disconnected:
            _showNoResponseOverlay(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Pinger Example',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.activeBlue,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 20,
          ),
          child: Text(
            generateRandomString(1000),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  void _showNoResponseOverlay(
    BuildContext context,
  ) {
    overlayEntry = OverlayEntry(
      builder: (context) => const Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: kBottomNavigationBarHeight,
          ),
          child: OverlayBody(),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry!);
  }

  @override
  void dispose() {
    overlayEntry?.remove();
    super.dispose();
  }
}
