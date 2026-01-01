class ApiMessageResponse {
  final bool success;
  final String? message;

  ApiMessageResponse({required this.success, this.message});

  factory ApiMessageResponse.fromJson(Map<String, dynamic> json) {
    return ApiMessageResponse(
      success: json['success'] == true,
      message: json['message']?.toString(),
    );
  }
}
