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

class CityClassData {
  String data;
  String message;
  List<CityClass> value;

  CityClassData({
    this.data,
    this.message,
    this.value,
  });

  factory CityClassData.fromJson(Map<String, dynamic> json) {
    return CityClassData(
        data: json['data'].toString(),
        message: json['message'].toString(),
        value: json['value']['all_users']
            .map<CityClass>((json) => CityClass.fromJson(json))
            .toList());
  }
}

class CityClass {
  String cityid;
  String name;

  CityClass({this.cityid, this.name});

  factory CityClass.fromJson(Map<String, dynamic> json) {
    return CityClass(
        cityid: json['id'].toString(), name: json['name'].toString());
  }
}

class City {
  String id;
  String name;

  City({this.id, this.name});

  factory City.fromJson(Map<String, dynamic> parsedJson) {
    return City(
        id: parsedJson["id"] as String, name: parsedJson["name"] as String);
  }
}
