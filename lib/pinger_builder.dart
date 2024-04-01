import 'package:flutter/material.dart';
import 'pinger_internet_status.dart';

/// A custom widget that reacts to internet connectivity changes.
///
/// This widget listens to a stream of internet connectivity updates provided by an instance
/// of `PingerInternetStatus`. Based on the current connectivity status, it dynamically switches
/// between showing a `connectedWidget` and a `disconnectedWidget`. Additionally, it can display
/// a `preInitWidget` before the initial internet status is determined, which is useful for showing
/// loading indicators or initial instructions to the user.
///
/// The `PingerInternetStatus` class is responsible for periodically checking the internet connection
/// by pinging specified URLs. It uses an isolate to perform these checks without blocking the main UI thread,
/// ensuring smooth user experiences. The class emits updates through a stream, which this widget subscribes to
/// via a `StreamBuilder`.
class PingerBuilder extends StatelessWidget {
  /// The widget to display when an internet connection is established.
  ///
  /// This should be a widget that represents the connected state of your application, such as
  /// the main content screen or a notification indicating that the internet is available.
  final Widget connectedWidget;

  /// The widget to display when there is no internet connection.
  ///
  /// This could be a screen informing the user of the lack of connectivity, providing
  /// options to retry the connection or displaying offline content.
  final Widget disconnectedWidget;

  /// An instance of `PingerInternetStatus` that provides the internet connectivity status.
  ///
  /// This instance should be initialized and configured prior to being passed to the
  /// `PingerBuilder` widget. It is responsible for emitting updates on the internet
  /// connectivity status through its stream, which this widget listens to.
  final PingerInternetStatus statusChecker;

  /// An optional widget to display before the initial internet status is determined.
  ///
  /// This widget is shown until the `PingerInternetStatus` instance emits its first update
  /// on the connectivity status. It is useful for displaying a loading spinner or a message
  /// instructing the user to wait until the check is completed.
  final Widget? preInitWidget;

  const PingerBuilder({
    Key? key,
    required this.connectedWidget,
    required this.disconnectedWidget,
    required this.statusChecker,
    this.preInitWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The StreamBuilder widget is used to build the UI dynamically based on the
    // stream of internet status updates. It listens to the stream provided by the
    // `statusChecker` instance.
    return StreamBuilder<PingerStatus>(
      // The stream of internet status updates to listen to.
      stream: statusChecker.status,
      builder: (context, snapshot) {
        // Before the stream becomes active (i.e., before the first update on internet status
        // is received), the `preInitWidget` is displayed. This handles the case where the
        // internet status check is still ongoing.
        if (snapshot.connectionState != ConnectionState.active) {
          // If `preInitWidget` is not provided, a SizedBox.shrink is returned instead,
          // effectively displaying nothing.
          return preInitWidget ?? const SizedBox.shrink();
        }

        // Once the stream is active, this checks the latest internet status and displays
        // either the `connectedWidget` or the `disconnectedWidget`, depending on whether
        // the internet connection is available or not.
        if (snapshot.data == PingerStatus.connected) {
          // When the internet is connected, display the `connectedWidget`.
          return connectedWidget;
        } else {
          // When there is no internet connection, display the `disconnectedWidget`.
          return disconnectedWidget;
        }
      },
    );
  }
}
