import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:dark_validator/utils/logger.dart';

import 'edf_data.dart';
import 'edf_header.dart';
import 'edf_signal.dart';
import 'edf_signal_header.dart';

/// A class for reading EDF+ (European Data Format Plus) files, supporting both encrypted
/// and unencrypted formats.
class EDFPlusReader {
  /// Creates a new EDFPlusReader instance
  /// @param filePath The path to the EDF+ file
  /// @param encryptService Service for handling encrypted files
  EDFPlusReader(this.filePath);
  final String filePath;
  late RandomAccessFile raf;

  /// Reads and parses the entire EDF+ file
  /// @returns EdfData containing header, signal headers, and signal data
  /// @throws Exception if reading fails
  Future<EdfData<T>> read<T>() async {
    try {
      await _open();

      final header = await _readHeader();
      final signalHeaders = await _readSignalHeaders(header.numSignals);
      final signals = await _readSignals<T>(header, signalHeaders);
      await _close();
      return EdfData<T>(header: header, signalHeaders: signalHeaders, signals: signals);
    } catch (e) {
      await _close();
      logError('Failed to read EDF file: ${e.toString()}', who: this);
      rethrow;
    }
  }

  /// Opens the file and determines if decryption is needed
  /// If the file is encrypted, decrypts it and creates an in-memory file
  Future<void> _open() async {
    final file = File(filePath);
    if (!file.existsSync()) {
      logError('EDF file not found: $filePath', who: this);
      throw Exception('EDF file not found: $filePath');
    }

    raf = await File(filePath).open(mode: FileMode.read);

    try {
      final result = await _readHeader();
      result.startDateTime; // Should be correct if not encrypted
      logWarning('Successfully read non-encrypted EDF file', who: this);
    } catch (e) {
      logError('Error reading EDF file: ${e.toString()}', who: this);
    }
  }

  /// Closes the file handle
  Future<void> _close() async {
    await raf.close();
  }

  /// Reads and parses the main EDF header (first 256 bytes)
  /// @returns EdfHeader containing file metadata
  Future<EdfHeader> _readHeader() async {
    raf.setPositionSync(0);
    final headerBytes = await raf.read(256);
    final headerString = String.fromCharCodes(headerBytes);
    return EdfHeader.fromString(headerString);
  }

  /// Reads and parses the signal headers for all signals in the file
  /// @param numSignals Number of signals to read headers for
  /// @returns List of EdfSignalHeader objects
  Future<List<EdfSignalHeader>> _readSignalHeaders(int numSignals) async {
    raf.setPositionSync(256);
    final signalHeaders = List.generate(numSignals, (_) => <List<int>>[]);

    // Read each field type for all signals
    for (final fieldLength in [16, 80, 8, 8, 8, 8, 8, 80, 8, 32]) {
      for (int i = 0; i < numSignals; i++) {
        final bytes = await raf.read(fieldLength);
        signalHeaders[i].add(bytes);
      }
    }

    // Convert the collected bytes into EdfSignalHeader objects
    return signalHeaders
        .map((headerBytes) => EdfSignalHeader.fromBytes(
              labelBytes: headerBytes[0],
              transducerBytes: headerBytes[1],
              unitsBytes: headerBytes[2],
              minPhysicalBytes: headerBytes[3],
              maxPhysicalBytes: headerBytes[4],
              minDigitalBytes: headerBytes[5],
              maxDigitalBytes: headerBytes[6],
              prefilteringBytes: headerBytes[7],
              samplesBytes: headerBytes[8],
              reservedBytes: headerBytes[9],
            ))
        .toList();
  }

  /// Reads the actual signal data in chunks to manage memory usage
  /// @param header Main EDF header
  /// @param signalHeaders List of signal headers
  /// @returns List of EdfSignal objects containing the signal data
  Future<List<EdfSignal<T>>> _readSignals<T>(EdfHeader header, List<EdfSignalHeader> signalHeaders) async {
    const headerSize = 256;
    final signalHeaderSize = 256 * signalHeaders.length;
    raf.setPositionSync(headerSize + signalHeaderSize);

    final numRecords = header.numRecords;
    final signals = List.generate(
      signalHeaders.length,
      (i) => EdfSignal<T>(samples: []),
    );

    // Process data in chunks to optimize memory usage
    const samplesPerChunk = 1000;
    final chunksNeeded = (numRecords / samplesPerChunk).ceil();

    try {
      for (var chunk = 0; chunk < chunksNeeded; chunk++) {
        // Calculate number of records in this chunk
        // For the last chunk, take remaining records
        final recordsInChunk = chunk == chunksNeeded - 1 ? numRecords - (chunk * samplesPerChunk) : samplesPerChunk;

        // Calculate total chunk size in bytes
        // For each signal: number of samples * 2 bytes per sample * number of records
        final chunkSize = signalHeaders.fold<int>(
          0,
          (sum, header) => sum + header.numSamples * 2 * recordsInChunk,
        );

        // Read chunk bytes from file
        final chunkBytes = await raf.read(chunkSize);
        var byteOffset = 0;

        // Process each record in the chunk
        for (var record = 0; record < recordsInChunk; record++) {
          // Process each signal in the record
          for (var signalIndex = 0; signalIndex < signalHeaders.length; signalIndex++) {
            final header = signalHeaders[signalIndex];
            final numSamples = header.numSamples;

            // Calculate scaling factors to convert digital values to physical values
            final scale = (header.physicalMax - header.physicalMin) / (header.digitalMax - header.digitalMin);
            final offset = header.physicalMin;

            // Process each sample in the signal
            for (var sample = 0; sample < numSamples; sample++) {
              // Combine two bytes into a 16-bit value (little-endian)
              final value = chunkBytes[byteOffset] | (chunkBytes[byteOffset + 1] << 8);
              // Convert to signed value if necessary (2's complement)
              final signedValue = (value & 0x8000) != 0 ? value - 0x10000 : value;

              if (T == Offset) {
                // Convert digital value to physical value using scaling factors
                final physicalValue = (signedValue - header.digitalMin) * scale + offset;

                // Round to 3 decimal places for precision
                final roundedValue = (physicalValue * 1000).round() / 1000;

                // Store the sample value (x=0 since we only care about y values)
                signals[signalIndex].samples.add(Offset(0, roundedValue) as T);
              } else {
                // Convert digital value to physical value using scaling factors
                final physicalValue = (signedValue - header.digitalMin) * scale + offset;
                signals[signalIndex].samples.add(physicalValue as T);
              }
              byteOffset += 2; // Move to next 2-byte sample
            }
          }
        }
      }
    } catch (e) {
      throw FormatException('Failed to read EDF signals: ${e.toString()}');
    }

    return signals;
  }
}

/// A class that implements RandomAccessFile interface for in-memory file operations
/// Used for handling decrypted data without writing to disk
// ignore: unused_element
class _InMemoryFile implements RandomAccessFile {
  _InMemoryFile(this._bytes);
  final Uint8List _bytes;
  int _position = 0;

  @override
  Future<Uint8List> read(int bytesToRead) async {
    final end = (_position + bytesToRead).clamp(0, _bytes.length);
    final data = _bytes.sublist(_position, end);
    _position = end;
    return Uint8List.fromList(data);
  }

  @override
  Future<RandomAccessFile> setPosition(int position) async {
    _position = position.clamp(0, _bytes.length);
    return this;
  }

  @override
  Future<void> close() async {
    // unimplemented
  }

  @override
  void closeSync() {
    // unimplemented
  }

  @override
  Future<RandomAccessFile> flush() {
    // unimplemented
    return Future.value(this);
  }

  @override
  void flushSync() {
    // unimplemented
  }

  @override
  Future<int> length() {
    // unimplemented
    return Future.value(_bytes.length);
  }

  @override
  int lengthSync() {
    // unimplemented
    return _bytes.length;
  }

  @override
  Future<RandomAccessFile> lock([FileLock mode = FileLock.exclusive, int start = 0, int end = -1]) {
    // unimplemented
    return Future.value(this);
  }

  @override
  void lockSync([FileLock mode = FileLock.exclusive, int start = 0, int end = -1]) {
    // unimplemented
  }

  @override
  String get path => '';

  @override
  Future<int> position() {
    // unimplemented
    return Future.value(_position);
  }

  @override
  int positionSync() {
    // unimplemented
    return _position;
  }

  @override
  Future<int> readByte() {
    // unimplemented
    return Future.value(_bytes[_position]);
  }

  @override
  int readByteSync() {
    // unimplemented
    return _bytes[_position];
  }

  @override
  Future<int> readInto(List<int> buffer, [int start = 0, int? end]) {
    // unimplemented
    return Future.value(0);
  }

  @override
  int readIntoSync(List<int> buffer, [int start = 0, int? end]) {
    // unimplemented
    return 0;
  }

  @override
  Uint8List readSync(int count) {
    // unimplemented
    return Uint8List.fromList([]);
  }

  @override
  void setPositionSync(int position) {
    // unimplemented
  }

  @override
  Future<RandomAccessFile> truncate(int length) {
    // unimplemented
    return Future.value(this);
  }

  @override
  void truncateSync(int length) {
    // unimplemented
  }

  @override
  Future<RandomAccessFile> unlock([int start = 0, int end = -1]) {
    // unimplemented
    return Future.value(this);
  }

  @override
  void unlockSync([int start = 0, int end = -1]) {
    // unimplemented
  }

  @override
  Future<RandomAccessFile> writeByte(int value) {
    // unimplemented
    return Future.value(this);
  }

  @override
  int writeByteSync(int value) {
    // unimplemented
    return 0;
  }

  @override
  Future<RandomAccessFile> writeFrom(List<int> buffer, [int start = 0, int? end]) {
    // unimplemented
    return Future.value(this);
  }

  @override
  void writeFromSync(List<int> buffer, [int start = 0, int? end]) {
    // unimplemented
  }

  @override
  Future<RandomAccessFile> writeString(String string, {Encoding encoding = utf8}) {
    // unimplemented
    return Future.value(this);
  }

  @override
  void writeStringSync(String string, {Encoding encoding = utf8}) {
    // unimplemented
  }
}
