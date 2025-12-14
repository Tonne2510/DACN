
class AccountInfor {
  String email;
  String sub;
  String role;
  String accessToken;
  String id;
  DateTime exp;
  AccountInfor(this.email, this.sub, this.role,this.accessToken,this.id, this.exp);

  factory AccountInfor.fromJson(Map<String, Object?> json){
    return AccountInfor(
        json['email'].toString(),
        json['sub'].toString(),
        json['role'].toString(),
        json['accessToken'].toString(),
        json['id'].toString(),
        DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecond+int.parse(json['exp'].toString()))
    );
  }
}