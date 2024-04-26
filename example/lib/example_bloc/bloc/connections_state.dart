part of 'connections_bloc.dart';

class ConnectionsState extends Equatable {
  final PingerStatus internetStatus;

  const ConnectionsState({this.internetStatus = PingerStatus.connected});

  ConnectionsState copyWith({
    PingerStatus? internetStatus,
  }) {
    return ConnectionsState(
      internetStatus: internetStatus ?? this.internetStatus,
    );
  }

  @override
  List<Object> get props => [internetStatus];
}
