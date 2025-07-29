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
    T Function(dynamic json) fromJsonT,
  ) {
    return ApiResponse<T>(
      data: fromJsonT(json['data']),
      message: json['message'] ?? '',
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
    );
  }
}

class PaginatedApiResponse<T> {
  final T data;
  final int currentPage;
  final int totalPages;
  final int pageSize;
  final int totalCount;
  final String message;
  final bool success;
  final int statusCode;

  PaginatedApiResponse({
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
    required this.totalCount,
    required this.message,
    required this.success,
    required this.statusCode,
  });

  factory PaginatedApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    return PaginatedApiResponse<T>(
      data: fromJsonT(json['data']),
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      totalCount: json['totalCount'] ?? 0,
      message: json['message'] ?? '',
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
    );
  }
}
