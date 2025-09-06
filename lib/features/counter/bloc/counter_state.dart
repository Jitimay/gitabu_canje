import 'package:equatable/equatable.dart';

class CounterState extends Equatable {
  final int value;

  const CounterState({this.value = 0});

  CounterState copyWith({int? value}) {
    return CounterState(value: value ?? this.value);
  }

  @override
  List<Object> get props => [value];
}