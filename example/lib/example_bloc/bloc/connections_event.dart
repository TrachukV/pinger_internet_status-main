part of 'connections_bloc.dart';

abstract class ConnectionsEvent {}

class InternetStatusChanged extends ConnectionsEvent {
  final PingerStatus status;
  InternetStatusChanged(this.status);
}
