
class CreatePostCommentRequest{

  final String? content;
  final String? postId;
  final String? accountId;

  CreatePostCommentRequest({
    this.content,
    this.postId,
    this.accountId,
  });

  Map<String, Object?> toMap() {
    return {
      "content": content,
      "postId":postId,
      "accountId": accountId,
    };
  }
}