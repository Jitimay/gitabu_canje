import 'package:flutter_bloc/flutter_bloc.dart';

import 'counter_event.dart';
import 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState()) {
    on<CounterIncremented>(_onCounterIncremented);
    on<CounterDecremented>(_onCounterDecremented);
    on<CounterReset>(_onCounterReset);
  }

  void _onCounterIncremented(
    CounterIncremented event,
    Emitter<CounterState> emit,
  ) {
    emit(state.copyWith(value: state.value + 1));
  }

  void _onCounterDecremented(
    CounterDecremented event,
    Emitter<CounterState> emit,
  ) {
    emit(state.copyWith(value: state.value - 1));
  }

  void _onCounterReset(
    CounterReset event,
    Emitter<CounterState> emit,
  ) {
    emit(const CounterState());
  }
}