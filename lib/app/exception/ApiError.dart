class ApiError {
  final String errorCode;
  final String message;
  final String details;

  ApiError({required this.errorCode, required this.message, required this.details});

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      errorCode: json['errorCode'],
      message: json['message'],
      details: json['details'],
    );
  }
}
