class PostCategory {
  final int id;
  final bool active;
  final int? parentId;
  final String postCategoryName;
  final String? slug;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? deletedAt;

  PostCategory({
    required this.id,
    required this.active,
    this.parentId,
    required this.postCategoryName,
    required this.slug,
    required this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.deletedAt,
  });

  factory PostCategory.fromJson(Map<String, dynamic> json) {
    return PostCategory(
      id: json['id'],
      active: json['active'],
      parentId: json['parentId'],
      postCategoryName: json['postCategoryName'],
      slug: json['slug'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }

}