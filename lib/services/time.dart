import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'time.g.dart';

@Riverpod(keepAlive: true)
class Time extends _$Time {
  @override
  double build() {
    return 0;
  }

  void toggle() {
    state = state == 1 ? 0 : 1;
  }

  void update(double value) {
    state = state + value;
    if (state < 0) {
      state = 0;
    }
  }
}
