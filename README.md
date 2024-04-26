# Pinger Internet Status Package

The "Pinger Internet Status Package" enables Flutter applications to monitor internet connectivity by periodically pinging specified URLs. This package includes a `PingerInternetStatus` class to manage connectivity checks and a `PingerStatusListener` widget to respond to connectivity changes.

## Features

- **Internet Connectivity Monitoring:** Regularly ping specific URLs to determine the internet connection status.
- **Asynchronous Operations:** Utilizes Dart isolates for conducting connectivity checks asynchronously, ensuring the main UI thread remains unblocked.
- **Responsive UI Components:** `PingerStatusListener` widget updates its display in response to real-time connectivity changes.
- **Customizable Settings:** Users can specify URLs, ping timeout durations, and opt-in for logging to customize the behavior as needed.
- **Non-blocking Design:** The implementation guarantees that the UI interactions remain smooth and responsive during connectivity checks.

## Getting Started

Follow these steps to integrate the Pinger Internet Status package into your Flutter application:

### Installation

1. Include `pinger_internet_status` in your project's `pubspec.yaml` file:

    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      pinger_internet_status: ^0.2.0
    ```

2. Import the package in your Flutter application:

    ```dart
    import 'package:pinger_internet_status/pinger_internet_status.dart';
    ```

### Usage

1. **Set up `PingerInternetStatus`:**

   Configure an instance of `PingerInternetStatus` by specifying URLs for connectivity checks and other optional parameters:

    ```dart
    final PingerInternetStatus pingerInternetStatus = PingerInternetStatus(
      hosts: ['https://google.com', 'https://example.com'],
      timeOut: 2, // Timeout in seconds
      logger: true, // Enable detailed logging for debug purposes
    );
    ```

2. **Incorporate `PingerStatusListener` into your widget tree:**

   Use `PingerStatusListener` to render widgets conditionally based on the current connectivity status:

    ```dart
    PingerStatusListener(
      statusChecker: pingerInternetStatus,
      builder: (PingerStatus status) => status == PingerStatus.connected
          ? Text('Connected to the Internet')
          : Text('Disconnected from the Internet'),
    );
    ```

## Examples in Action

Below are GIFs demonstrating the package in use with different architectural approaches:

## Examples in Action

Below are GIFs demonstrating the package in use with different architectural approaches:

| BLoC Example                                  | StreamBuilder Example                              |
|------------------------------------------|----------------------------------------------------|
| <img src="https://github.com/TrachukV/pinger_internet_status-main/blob/main/example_bloc.gif" width="300"> | <img src="https://github.com/TrachukV/pinger_internet_status-main/blob/main/example_streambuilder.gif" width="300"> |
| [View BLoC Example Code](https://github.com/TrachukV/pinger_internet_status-main/tree/main/example/lib/example_bloc) | [View StreamBuilder Example Code](https://github.com/TrachukV/pinger_internet_status-main/blob/main/example/lib/example_stream_builder/main.dart) |

These examples showcase how the `PingerInternetStatus` can be integrated into Flutter applications using different state management techniques.


## Contributing

Contributions to improve the package or extend its capabilities are highly encouraged. Feel free to fork the repository, make your changes, and submit a pull request.

## License

This software is released under the MIT License. For more details, please refer to the LICENSE file included in the package.
