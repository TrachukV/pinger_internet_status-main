# Internet Connectivity Widget Package

This package provides a simple yet powerful way to monitor internet connectivity within your Flutter applications. Featuring `PingerInternetStatus`, a class that periodically checks internet connectivity by pinging specified URLs, and `InternetStatusBuilder`, a widget that reacts to connectivity changes, this package ensures your app remains responsive and informative regarding its connection status.

## Features

- **Internet Connectivity Monitoring:** Periodically ping specified URLs to check for internet connectivity.
- **Asynchronous Updates:** Utilizes Dart isolates to perform connectivity checks without blocking the main UI thread.
- **Dynamic UI Responses:** Includes `InternetStatusBuilder`, a widget that updates its display based on the current internet connectivity status.
- **Customizable Connectivity Checks:** Configure URLs and ping intervals to suit your app's needs.
- **Optional Logging:** Control console logging for connectivity checks and ping results.

## Getting Started

To get started with the Internet Connectivity Widget Package, follow these simple steps:

### Installation

1. Add `your_package_name` to your `pubspec.yaml` under the dependencies section:

    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      your_package_name: latest_version
    ```

2. Import the package in your Flutter app:

    ```dart
    import 'package:your_package_name/pinger_internet_status.dart';
    ```

### Usage

1. **Initialize `PingerInternetStatus`:**

   Create an instance of `PingerInternetStatus`, specifying the URLs to ping and the timeout interval.

    ```dart
    final PingerInternetStatus pingerInternetStatus = PingerInternetStatus(
      urls: ['https://google.com', 'https://example.com'],
      timeOut: 2, // Timeout in seconds
      logger: true, // Enable logging for debugging purposes
    );
    ```

2. **Use `InternetStatusBuilder` in Your Widget Tree:**

   Incorporate `InternetStatusBuilder` into your app's widget tree to dynamically display widgets based on the internet connectivity status.

    ```dart
    PingerBuilder(
      statusChecker: pingerInternetStatus,
      connectedWidget: Text('Connected to the Internet'),
      disconnectedWidget: Text('Disconnected from the Internet'),
      preInitWidget: CircularProgressIndicator(), // Optional: Shown until the first connectivity check completes.
    )
    ```

## Example

See the `/example` folder for a detailed Flutter app example using this package.

## Contributing

Contributions are welcome! If you find a bug or have a feature request, please open an issue on our GitHub repository.

## License

This package is licensed under the MIT License. See the LICENSE file for details.
