import 'package:flutter_test/flutter_test.dart';
import 'package:ayur_sathi/models/feature.dart';

void main() {
  test('all ten features are registered', () {
    expect(features.length, 10);
    expect(features.first.id, 1);
    expect(features.last.id, 10);
  });

  test('features provide Hindi and English titles', () {
    expect(features.every((f) => f.titleHi.isNotEmpty && f.titleEn.isNotEmpty), isTrue);
  });
}
