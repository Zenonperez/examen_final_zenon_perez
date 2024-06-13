import 'dart:convert';

/**
 * Modelo tiene las variables de nuestro corredor y como se mapeara a la base de datos e inversamente
 */
class Runner {
  Runner({
    this.id,
    required this.name,
    required this.time,
    required this.position,
    required this.bibnumber,
    required this.photofinish,
  });
  String? id;
  String name;
  String time;
  String position;
  String bibnumber;
  String photofinish;

  factory Runner.fromJson(String str) => Runner.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Runner.fromMap(Map<String, dynamic> json) => Runner(
      name: json["name"],
      time: json["time"],
      position: json["position"],
      bibnumber: json["bibnumber"],
      photofinish: json["photofinish"]);

  Map<String, dynamic> toMap() => {
        "name": name,
        "time": time,
        "position": position,
        "bibnumber": bibnumber,
        "photofinish": photofinish
      };

  Runner copy() => Runner(
      name: name,
      time: time,
      bibnumber: bibnumber,
      position: position,
      photofinish: photofinish,
      id: id);
}
