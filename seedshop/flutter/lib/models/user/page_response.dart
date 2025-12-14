
class PageResponse<T>{
  int pageNumber;
  int pageSize;
  int totalRecords;
  List<T> data;

  PageResponse({ required this.pageNumber, required this.pageSize, required this.totalRecords,required this.data});
  factory PageResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return PageResponse(
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      totalRecords: json['totalRecords'],
      data: (json['data'] as List).map((item) => fromJsonT(item as Map<String, dynamic>)).toList(),
    );
  }

}