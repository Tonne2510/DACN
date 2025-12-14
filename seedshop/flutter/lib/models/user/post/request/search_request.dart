
class PostSearchRequest{
  int? pageNumber = 1;
  int? pageSize = 10;
  final String? keyword;
  final String? status;
  final String? sortBy;
  final String? sortDir;
  String? postCategoryId;
  String? isPublish;

  PostSearchRequest({
    this.pageNumber,
    this.pageSize,
    this.keyword,
    this.status,
    this.sortBy,
    this.sortDir,
    this.postCategoryId,
    this.isPublish
  });

  Map<String, Object?> toMap() {
    return {
      "pageNumber": pageNumber,
      "pageSize":pageSize,
      "keyword": keyword,
      "status": status,
      "sortBy":sortBy,
      "sortDir": sortDir,
      "postCategoryId": postCategoryId,
      "isPublish": isPublish
    };
  }
}