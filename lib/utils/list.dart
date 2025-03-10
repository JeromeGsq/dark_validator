extension ListExtension<T> on List<T> {
  List<T> safeSublist(int start, [int? end]) {
    start = start.clamp(0, length);
    end = end?.clamp(0, length) ?? length;

    return sublist(start, end);
  }
}
