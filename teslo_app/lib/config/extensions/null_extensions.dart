bool? nullExtensions;

extension IntNullExtension on int? {
  int value([defaultValue = 0]) {
    return this ?? defaultValue;
  }
}

extension StringNullExtension on String? {
  String value([defaultValue = '']) {
    return this ?? defaultValue;
  }

  String valueEmpty(String defaultValue) {
    if (this == null) return defaultValue;
    if (this!.isEmpty) return defaultValue;
    if (this!.trim() == '-') return defaultValue;
    return this!;
  }
}

extension NumNullExtensions on num? {
  num value([defaultValue = 0.0]) {
    return this ?? defaultValue;
  }
}

extension DoubleNullExtensions on double? {
  double value([defaultValue = 0.0]) {
    return this ?? defaultValue;
  }
}

extension BoolNullExtension on bool? {
  bool value([defaultValue = false]) {
    return this ?? defaultValue;
  }
}

extension ListFirstExts on List {
  dynamic get firstOrNull {
    if (isEmpty) return null;
    return first;
  }
  dynamic get firstOrNull2 {
    if (isEmpty) return null;
    return first;
  }
}

extension SwappableList<T> on List<T> {
  void swap(int first, int second) {
    final temp = this[first];
    this[first] = this[second];
    this[second] = temp;
  }
}

extension ListExts<T> on List<T>? {
  List<T> value() {
    return this ?? <T>[];
  }
}