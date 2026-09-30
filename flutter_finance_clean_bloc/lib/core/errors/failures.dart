sealed class Failure {
  const Failure(this.message);
  final String message;
}

final class CacheFailure extends Failure {
  const CacheFailure([
    super.message = 'No se pudieron guardar o cargar los movimientos.',
  ]);
}
