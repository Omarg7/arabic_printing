// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:enough_convert/enough_convert.dart';

/// An instance of the default implementation of the [LatinArabic].
///
/// This instance provides a convenient access to the most common ISO Latin 1
/// use cases.
///
/// Examples:
/// ```dart
/// var encoded = latin1.encode("blåbærgrød");
/// var decoded = latin1.decode([0x62, 0x6c, 0xe5, 0x62, 0xe6,
///                              0x72, 0x67, 0x72, 0xf8, 0x64]);
/// ```
const LatinArabic latinArabic = LatinArabic();

const int _latinArabicMask = 0xFF;

/// A [LatinArabic] encodes strings to ISO Latin-1 (aka ISO-8859-1) bytes
/// and decodes Latin-1 bytes to strings.
class LatinArabic extends Encoding {
  final bool _allowInvalid;

  /// Instantiates a new [LatinArabic].
  ///
  /// If [allowInvalid] is true, the [decode] method and the converter
  /// returned by [decoder] will default to allowing invalid values. Invalid
  /// values are decoded into the Unicode Replacement character (U+FFFD).
  /// Calls to the [decode] method can override this default.
  ///
  /// Encoders will not accept invalid (non Latin-1) characters.
  const LatinArabic({bool allowInvalid = false}) : _allowInvalid = allowInvalid;

  /// The name of this codec, "iso-8859-6".
  String get name => "iso-8859-6";

  Uint8List encode(String source) => encoder.convert2(source);

  /// Decodes the Latin-1 [bytes] (a list of unsigned 8-bit integers) to the
  /// corresponding string.
  ///
  /// If [bytes] contains values that are not in the range 0 .. 255, the decoder
  /// will eventually throw a [FormatException].
  ///
  /// If [allowInvalid] is not provided, it defaults to the value used to create
  /// this [LatinArabic].
  ///
  ///

  // String decode(List<int> bytes, {bool? allowInvalid}) {
  //   if (allowInvalid ?? _allowInvalid) {
  //     return const Latin1Decoder(allowInvalid: true).convert(bytes);
  //   } else {
  //     return const Latin1Decoder(allowInvalid: false).convert(bytes);
  //   }
  // }

  LatinArabicEncoder get encoder => const LatinArabicEncoder();

  Latin1Decoder get decoder => _allowInvalid
      ? const Latin1Decoder(allowInvalid: true)
      : const Latin1Decoder(allowInvalid: false);
}

class LatinArabicEncoder extends _UnicodeSubsetEncoder {
  const LatinArabicEncoder() : super(_latinArabicMask);
}

/// This class converts Latin-1 bytes (lists of unsigned 8-bit integers)
/// to a string.
///
/// Example:
/// ```dart
/// final latin1Decoder = latin1.decoder;
///
/// const encodedBytes = [224, 225, 226, 227, 228, 229];
/// final decoded = latin1Decoder.convert(encodedBytes);
/// print(decoded); // àáâãäå
///
/// // Hexadecimal values as source
/// const hexBytes = [0xe0, 0xe1, 0xe2, 0xe3, 0xe4, 0xe5];
/// final decodedHexBytes = latin1Decoder.convert(hexBytes);
/// print(decodedHexBytes); // àáâãäå
/// ```
/// Throws a [FormatException] if the encoded input contains values that are
/// not in the range 0 .. 255 and [allowInvalid] is false ( the default ).
///
/// If [allowInvalid] is true, invalid bytes are converted
/// to Unicode Replacement character U+FFFD (�).
///
/// Example with `allowInvalid` set to true:
/// ```dart
/// const latin1Decoder = Latin1Decoder(allowInvalid: true);
/// const encodedBytes = [300];
/// final decoded = latin1Decoder.convert(encodedBytes);
/// print(decoded); // �
/// ```

class _UnicodeSubsetEncoder extends Converter<String, List<int>> {
  final int _subsetMask;

  const _UnicodeSubsetEncoder(this._subsetMask);

  /// Converts the [String] into a list of its code units.
  ///
  /// If [start] and [end] are provided, only the substring
  /// `string.substring(start, end)` is used as input to the conversion.
  Uint8List convert(String string, [int start = 0, int? end]) {
    print('inside arabic convert');

    var stringLength = string.length;
    end = RangeError.checkValidRange(start, end, stringLength);
    var length = end - start;
    var result = Uint8List(length);
    var reversedRes = Uint8List(length);
    final codec = Latin6Codec(allowInvalid: false);

    var codeUnit = codec.encode(string);
    print(codeUnit);
    final codeUnitList = Uint8List.fromList(codeUnit);
    print(codeUnitList);
    result = codeUnitList;
    for (int i = result.length - 1; i <= 0; i--) {
      print(result[i]);
      reversedRes.add(result[i]);
    }
    return reversedRes;
  }

  Uint8List convert2(String string, [int start = 0, int? end]) {
    print('inside arabic convert');

    var stringLength = string.length;
    end = RangeError.checkValidRange(start, end, stringLength);
    var length = end - start;
    var result = Uint8List(length);
    var reversedRes = Uint8List(length);
    final codec = Latin6Codec(allowInvalid: false);

    var codeUnit = codec.encode(string);
    final data = codeUnit.reversed.toList();
    print(data);
    print(codeUnit);
    final codeUnitList = Uint8List.fromList(codeUnit);
    final dataUnitList = Uint8List.fromList(data);
    print(dataUnitList);
    print(codeUnitList);
    result = dataUnitList;

    return result;
  }

  /// Starts a chunked conversion.
  ///
  /// The converter works more efficiently if the given [sink] is a
  /// [ByteConversionSink].
  arabicEncoder(String x) {
    switch (x) {
      case '':
        return;
    }
  }

  StringConversionSink startChunkedConversion(Sink<List<int>> sink) {
    return _UnicodeSubsetEncoderSink(_subsetMask,
        sink is ByteConversionSink ? sink : ByteConversionSink.from(sink));
  }

  // Override the base-class' bind, to provide a better type.
  Stream<List<int>> bind(Stream<String> stream) => super.bind(stream);
}

class _UnicodeSubsetEncoderSink extends StringConversionSinkBase {
  final ByteConversionSink _sink;
  final int _subsetMask;

  _UnicodeSubsetEncoderSink(this._subsetMask, this._sink);

  void close() {
    _sink.close();
  }

  void addSlice(String source, int start, int end, bool isLast) {
    RangeError.checkValidRange(start, end, source.length);
    for (var i = start; i < end; i++) {
      var codeUnit = source.codeUnitAt(i);
      if ((codeUnit & ~_subsetMask) != 0) {
        throw ArgumentError(
            "Source contains invalid character with code point: $codeUnit.");
      }
    }
    _sink.add(source.codeUnits.sublist(start, end));
    if (isLast) {
      close();
    }
  }
}
