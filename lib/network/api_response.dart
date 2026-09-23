sealed class ApiResult<T> {}

class Success<T> extends ApiResult<T> {
  final T data;
  Success(this.data);
}

class ErrorResult<T> extends ApiResult<T> {
  final String message;
  ErrorResult(this.message);
}