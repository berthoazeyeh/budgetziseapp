class ApiResponse<T> {
  final T data;
  final String message;
  final bool success;
  final int statusCode;

  ApiResponse({
    required this.data,
    required this.message,
    required this.success,
    required this.statusCode,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return ApiResponse(
      data: fromJsonT(json['data'] ?? {}),
      message: json['message'] ?? '',
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
    );
  }
}
