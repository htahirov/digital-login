import 'dart:math';

/// A helper class to generate UUID-like random identifiers.
class UuidHelper {
  /// Generates a random UUID string.
  ///
  /// The format follows the standard UUID format: `8-4-4-4-12` hex characters.
  static String generateUuid() {
    final random = Random();

    /// Generates a section of the UUID with the given [length].
    String formatSection(int length) =>
        List.generate(length, (index) => random.nextInt(16).toRadixString(16))
            .join();

    return '${formatSection(8)}-${formatSection(4)}-${formatSection(4)}-${formatSection(4)}-${formatSection(12)}';
  }
}
