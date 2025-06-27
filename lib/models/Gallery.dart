class GalleryImageResponse {
  final String status;
  final String message;
  final List<GalleryImage> data;

  GalleryImageResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GalleryImageResponse.fromJson(Map<String, dynamic> json) {
    return GalleryImageResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: List<GalleryImage>.from(
        (json['data'] ?? []).map((item) => GalleryImage.fromJson(item)),
      ),
    );
  }
}

class GalleryImage {
  final int id;
  final String imageUrl;
  final String? uploadedBy;
  final DateTime createdAt;

  GalleryImage({
    required this.id,
    required this.imageUrl,
    required this.uploadedBy,
    required this.createdAt,
  });

  factory GalleryImage.fromJson(Map<String, dynamic> json) {
    return GalleryImage(
      id: json['id'],
      imageUrl: json['imageUrl'],
      uploadedBy: json['uploadedBy'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
