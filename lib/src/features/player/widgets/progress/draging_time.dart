
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'draging_time.g.dart';


@Riverpod(keepAlive: true)
class DragingTime extends _$DragingTime{

  @override
  Duration build() => Duration.zero;

  void update(Duration value) {
    state = value;
  }

  void reset() {
    state = Duration.zero;
  }
}