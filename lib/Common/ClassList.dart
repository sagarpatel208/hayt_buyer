class SaveDataClass {
  String message;
  String data;
  List value;

  SaveDataClass({this.message, this.data, this.value});

  factory SaveDataClass.fromJson(Map<String, dynamic> json) {
    return SaveDataClass(
        message: json['message'] as String,
        data: json['data'] as String,
        value: json['value'] as List);
  }
}
