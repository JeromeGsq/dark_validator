import 'edf_header.dart';
import 'edf_signal.dart';
import 'edf_signal_header.dart';

class EdfData<T> {
  EdfData({
    required this.header,
    required this.signalHeaders,
    required this.signals,
  });

  final EdfHeader header;
  final List<EdfSignalHeader> signalHeaders;
  final List<EdfSignal<T>> signals;
}
