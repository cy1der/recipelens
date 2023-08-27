enum ApiResultType { success, failure }

class ApiResult<T> {
  final ApiResultType type;
  final T? data;
  final int statusCode;

  ApiResult.success({this.data, this.statusCode = 200})
      : type = ApiResultType.success;
  ApiResult.error(this.statusCode)
      : data = null,
        type = ApiResultType.failure;
}
