/// Generic API response model
class ApiResponseModel<T> {
  final bool success;
  final T? data;
  final String? message;
  final String? error;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  const ApiResponseModel._({
    required this.success,
    this.data,
    this.message,
    this.error,
    this.statusCode,
    this.errors,
  });

  factory ApiResponseModel.success({
    T? data,
    String? message,
    bool success = true,
  }) {
    return ApiResponseModel._(success: success, data: data, message: message);
  }

  factory ApiResponseModel.error(
    String error, {
    int? statusCode,
    Map<String, dynamic>? errors,
  }) {
    return ApiResponseModel._(
      success: false,
      error: error,
      statusCode: statusCode,
      errors: errors,
    );
  }

  factory ApiResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? fromJsonT,
  ) {
    return ApiResponseModel._(
      success: json['success'] as bool,
      data:
          json['data'] != null && fromJsonT != null
              ? fromJsonT(json['data'] as Map<String, dynamic>)
              : json['data'] as T?,
      message: json['message'] as String?,
      error: json['error'] as String?,
      statusCode: json['status_code'] as int?,
      errors: json['errors'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data,
      'message': message,
      'error': error,
      'status_code': statusCode,
      'errors': errors,
    };
  }

  @override
  String toString() {
    return 'ApiResponseModel(success: $success, data: $data, message: $message, error: $error)';
  }
}
