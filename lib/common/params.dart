// ignore: public_member_api_docs
class Params {
  // ignore: always_specify_types, public_member_api_docs, prefer_typing_uninitialized_variables
  var arg1;
  // ignore: always_specify_types, public_member_api_docs, prefer_typing_uninitialized_variables
  var arg2;

  // ignore: public_member_api_docs
  Params({
    this.arg1,
    this.arg2,
  });

  // ignore: public_member_api_docs
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'arg1': arg1,
      'arg2': arg2,
    };
  }

  // ignore: public_member_api_docs
  factory Params.fromMap(Map<String, dynamic> map) {
    return Params(
      arg1: map['arg1'],
      arg2: map['arg2'],
    );
  }
}
