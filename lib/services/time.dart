import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'time.g.dart';

@Riverpod(keepAlive: true)
class Time extends _$Time {
  @override
  double build() {
    return 0;
  }

  void update(double value) {
    state = state + value;
    if (state < 0) {
      state = 0;
    }

    if (state > 10) {
      state = 10;
    }
  }
}
