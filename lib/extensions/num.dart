extension NumExtension on Iterable<num> {
  num computeMean() {
    return reduce((value, element) => value + element) / length;
  }

  num computeMedian() {
    final sortedList = toList()..sort();
    final middle = sortedList.length ~/ 2;

    if (sortedList.length.isEven) {
      return (sortedList[middle] + sortedList[middle - 1]) / 2;
    } else {
      return sortedList[middle];
    }
  }
}

extension DoubleExtension on Iterable<double> {
  double computeMean() {
    return reduce((value, element) => value + element) / length;
  }

  double computeMedian() {
    final sortedList = toList()..sort();
    final middle = sortedList.length ~/ 2;

    if (sortedList.length.isEven) {
      return (sortedList[middle] + sortedList[middle - 1]) / 2;
    } else {
      return sortedList[middle].toDouble();
    }
  }
}

extension IntExtension on Iterable<int> {
  double computeMean() {
    return reduce((value, element) => value + element) / length;
  }

  double computeMedian() {
    final sortedList = toList()..sort();
    final middle = sortedList.length ~/ 2;

    if (sortedList.length.isEven) {
      return (sortedList[middle] + sortedList[middle - 1]) / 2;
    } else {
      return sortedList[middle].toDouble();
    }
  }
}
