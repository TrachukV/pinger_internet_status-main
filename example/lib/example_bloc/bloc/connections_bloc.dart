import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinger_internet_status/pinger_internet_status.dart';

part 'connections_event.dart';

part 'connections_state.dart';

class ConnectionsBloc extends Bloc<ConnectionsEvent, ConnectionsState> {
  final PingerInternetStatus pingerInternetStatus;
  late final StreamSubscription<PingerStatus> internetStatusSubscription;

  ConnectionsBloc(this.pingerInternetStatus) : super(const ConnectionsState()) {
    internetStatusSubscription = pingerInternetStatus.status.listen((status) {
      add(InternetStatusChanged(status));
    }, onError: (error) {
      log('Error listening to internet status: $error');
    });

    on<InternetStatusChanged>((event, emit) {
      emit(state.copyWith(internetStatus: event.status));
    });
  }

  @override
  Future<void> close() {
    internetStatusSubscription.cancel();
    return super.close();
  }
}
