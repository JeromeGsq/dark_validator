class EdfSignalHeader {
  EdfSignalHeader({
    required this.label,
    required this.transducer,
    required this.units,
    required this.physicalMin,
    required this.physicalMax,
    required this.digitalMin,
    required this.digitalMax,
    required this.prefiltering,
    required this.numSamples,
    required this.reserved,
  });

  factory EdfSignalHeader.fromBytes({
    required List<int> labelBytes,
    required List<int> transducerBytes,
    required List<int> unitsBytes,
    required List<int> minPhysicalBytes,
    required List<int> maxPhysicalBytes,
    required List<int> minDigitalBytes,
    required List<int> maxDigitalBytes,
    required List<int> prefilteringBytes,
    required List<int> samplesBytes,
    required List<int> reservedBytes,
  }) {
    return EdfSignalHeader(
      label: String.fromCharCodes(labelBytes).trim(),
      transducer: String.fromCharCodes(transducerBytes).trim(),
      units: String.fromCharCodes(unitsBytes).trim(),
      physicalMin: double.tryParse(String.fromCharCodes(minPhysicalBytes).trim()) ?? 0.0,
      physicalMax: double.tryParse(String.fromCharCodes(maxPhysicalBytes).trim()) ?? 0.0,
      digitalMin: int.tryParse(String.fromCharCodes(minDigitalBytes).trim()) ?? 0,
      digitalMax: int.tryParse(String.fromCharCodes(maxDigitalBytes).trim()) ?? 0,
      prefiltering: String.fromCharCodes(prefilteringBytes).trim(),
      numSamples: int.tryParse(String.fromCharCodes(samplesBytes).trim()) ?? 0,
      reserved: String.fromCharCodes(reservedBytes).trim(),
    );
  }

  final String label;
  final String transducer;
  final String units;
  final double physicalMin;
  final double physicalMax;
  final int digitalMin;
  final int digitalMax;
  final String prefiltering;
  final int numSamples;
  final String reserved;
}
