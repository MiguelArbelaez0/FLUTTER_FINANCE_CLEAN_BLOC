/// Two decimal places; bounded to preserve exact integer arithmetic on web.
class Money {
  static const maxAmount = 1000000000.0;

  static int cents(double value) {
    if (!value.isFinite || value.abs() > 90071992547409) {
      throw ArgumentError('Monto fuera de rango');
    }
    return (value * 100).round();
  }

  static double? parse(String input) {
    final text = input.trim();
    if (!RegExp(r'^\d+(?:[.,]\d{1,2})?$').hasMatch(text)) return null;
    final value = double.tryParse(text.replaceAll(',', '.'));
    if (value == null || !value.isFinite || value <= 0 || value > maxAmount) {
      return null;
    }
    return cents(value) / 100;
  }
}
