final class CacheException implements Exception {
  const CacheException([this.message = 'Local storage operation failed.']);
  final String message;
}
