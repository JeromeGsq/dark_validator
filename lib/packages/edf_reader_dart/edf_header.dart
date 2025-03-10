class EdfHeader {
  EdfHeader({
    required this.version,
    required this.patientID,
    required this.recordID,
    required this.startDate,
    required this.startTime,
    required this.headerSize,
    required this.reserved,
    required this.numRecords,
    required this.recordDuration,
    required this.numSignals,
  });

  factory EdfHeader.fromString(String header) {
    return EdfHeader(
      version: header.substring(0, 8).trim(),
      patientID: header.substring(8, 88).trim(),
      recordID: header.substring(88, 168).trim(),
      startDate: header.substring(168, 176).trim(),
      startTime: header.substring(176, 184).trim(),
      headerSize: int.tryParse(header.substring(184, 192).trim()) ?? 0,
      reserved: header.substring(192, 236).trim(),
      numRecords: int.tryParse(header.substring(236, 244).trim()) ?? 0,
      recordDuration: double.tryParse(header.substring(244, 252).trim()) ?? 0.0,
      numSignals: int.tryParse(header.substring(252, 256).trim()) ?? 0,
    );
  }

  final String version;
  final String patientID;
  final String recordID;
  final String startDate;
  final String startTime;
  final int headerSize;
  final String reserved;
  final int numRecords;
  final double recordDuration;
  final int numSignals;

  /// Returns the start date and time of the record.
  ///
  /// The date is in the format of YY.MM.DD and the time is in the format of HH.MM.SS.
  /// The EDF format does not specify the century, so we assume it's in the 20th century.
  DateTime get startDateTime {
    final dateParts = startDate.split('.');
    final timeParts = startTime.split('.');

    /// If you have a RangeError (RangeError (length): Invalid value: Only valid value is 0: 2)
    /// it means that the date is not in the correct format.
    /// That's normal and you can ignore it.
    /// I use this to check if the EDF file is valid.
    return DateTime(
      int.parse('20${dateParts[2]}'),
      int.parse(dateParts[1]),
      int.parse(dateParts[0]),
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
      int.parse(timeParts[2]),
    );
  }
}
