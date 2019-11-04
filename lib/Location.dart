import 'dart:convert';

import 'package:http/http.dart' as http;

//{status: 200, result: {prefecture: {pcode: 34, pname: 広島県},
//municipality: {mname: 福山市, mcode: 34207},
//local: [{section: 西深津町六丁目, homenumber: 12, distance: 12.0734146643508, latitude: 34.501616, longitude: 133.384224}]},
//argument: {latitude: 34.50165844222924, longitude: 133.3843445777893, localradius: 500, localmax: 1},
//meta: [{name: thanks, content: このサービスは 国土交通省 提供 国土数値情報(行政区域) を利用しています}, {name: thanks, content: このサービスは 国土交通省 提供 街区レベル位置参照情報および大字・町丁目レベル位置参照情報 を利用しています}]}

class Location {
  final url = 'https://www.finds.jp/ws/rgeocode.php';
  Future<LocationEntity> detectLocale(double lat, double lon) async {
    final param = 'lat=${lat}&lon=${lon}';
    final response = await http.post('${url}?json&${param}');
    final json = jsonDecode(response.body);
    return LocationEntity.fromJson(json['result']);
  }
}

class LocationEntity {
  LocationStructure prefecture;
  LocationStructure municipality;
  LocationEntity.fromJson(Map<String,dynamic> json) {
    prefecture = json.containsKey('prefecture') ? LocationStructure(json['prefecture']['pcode'],json['prefecture']['pname']):null;
    municipality = json.containsKey('municipality') ? LocationStructure(json['municipality']['mcode'],json['municipality']['mname']):null;
  }
}

class LocationStructure {
  int code;
  String name;
  LocationStructure(this.code, this.name){}
}